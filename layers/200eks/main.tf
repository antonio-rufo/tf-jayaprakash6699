###############################################################################
# Providers
###############################################################################
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_profile
}

###############################################################################
# Terraform main config
###############################################################################
terraform {
  required_version = ">= 1.1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.57.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }

  backend "s3" {
    bucket  = "XXXXXXXXXXXXXX-build-state-bucket-eks-helm-project"
    key     = "terraform.development.200eks.tfstate"
    region  = "XXXXXXXXXXXXXX"
    encrypt = "true"
    profile = "XXXXXXXXXXXXXX"
  }
}

###############################################################################
# Terraform Remote State
###############################################################################
data "terraform_remote_state" "base_network" {
  backend = "s3"

  config = {
    bucket  = "XXXXXXXXXXXXXX-build-state-bucket-eks-helm-project"
    key     = "terraform.development.000base.tfstate"
    region  = "XXXXXXXXXXXXXX"
    encrypt = "true"
    profile = "XXXXXXXXXXXXXX"
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

locals {
  vpc_id          = data.terraform_remote_state.base_network.outputs.vpc_id
  private_subnets = data.terraform_remote_state.base_network.outputs.private_subnets
  public_subnets  = data.terraform_remote_state.base_network.outputs.public_subnets
  cluster_name    = var.cluster_name
  tags = {
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

###############################################################################
# Security Groups - Bastion
###############################################################################
module "bastion_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = var.bastion_sg_name
  description = var.bastion_sg_description
  vpc_id      = local.vpc_id
  tags        = merge(local.tags, { "Name" : var.bastion_sg_name })


  ingress_cidr_blocks = var.bastion_sg_source_cidr_block
  ingress_rules       = var.bastion_sg_ingress_rules

  egress_rules = ["all-all"]

}

###############################################################################
# Bastion Instance Profile
###############################################################################
module "bastion_instance_profile" {
  source = "../../modules/bastion_instance_profile"

  bastion_role_name             = var.bastion_role_name
  bastion_instance_profile_name = var.bastion_instance_profile_name

  tags = local.tags
}

###############################################################################
# Bastion
###############################################################################
module "bastion" {
  source = "../../modules/bastion"

  bastion_name           = var.bastion_name
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = local.public_subnets[0]
  vpc_security_group_ids = [module.bastion_security_group.security_group_id]
  user_data              = var.user_data
  iam_instance_profile   = module.bastion_instance_profile.bastion_instance_profile

  tags = local.tags
}

###############################################################################
# Security Groups - EKS Worker Nodes
###############################################################################
module "eks_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = var.eks_sg_name
  description = var.eks_sg_description
  vpc_id      = local.vpc_id
  tags        = merge(local.tags, { "Name" : var.eks_sg_name })

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bastion_security_group.security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]
}

###############################################################################
# Modules - EKS
###############################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = local.cluster_name
  cluster_version = var.eks_cluster_version
  subnets         = local.private_subnets

  map_roles = [{
    rolearn  = module.bastion_instance_profile.bastion_role_arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups   = ["system:bootstrappers", "system:nodes"]
  }]

  tags = {
    Environment = var.environment
  }

  vpc_id = local.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = var.worker_nodes_name
      instance_type                 = var.worker_nodes_instance_type
      asg_desired_capacity          = var.worker_nodes_asg_desired_capacity
      additional_security_group_ids = [module.eks_security_group.security_group_id]
    },
  ]
}
