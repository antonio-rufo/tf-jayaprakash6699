###############################################################################
# Providers
###############################################################################
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_profile
}

locals {
  cluster_name = var.cluster_name
  tags = {
    Environment = var.environment
  }
}

###############################################################################
# Terraform main config
###############################################################################
terraform {
  required_version = ">= 1.1.5"
  required_providers {
    aws = "~> 3.74.0"
  }
  backend "s3" {
    bucket  = "XXXXXXXXXXXXXX-build-state-bucket-eks-helm-project"
    key     = "terraform.development.000base.tfstate"
    region  = "XXXXXXXXXXXXXX"
    encrypt = "true"
    profile = "XXXXXXXXXXXXXX"
  }
}

###############################################################################
# Data Sources
###############################################################################
data "aws_availability_zones" "available" {
}

###############################################################################
# Base Network
###############################################################################
module "base_network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name                 = var.vpc_name
  cidr                 = var.cidr_range
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.public_cidr_ranges
  public_subnets       = var.private_cidr_ranges
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
