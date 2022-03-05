###############################################################################
# Variables - Environment
###############################################################################
variable "aws_account_id" {
  description = "AWS Account ID"
}

variable "aws_profile" {
  description = "The AWS account profile to use."
  type        = string
}

variable "region" {
  description = "Default Region"
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Name of the environment for the deployment, e.g. Integration, PreProduction, Production, QA, Staging, Test"
  default     = "Development"
}

###############################################################################
# Variables - EKS
###############################################################################
variable "cluster_name" {
  description = "EKS Cluster name"
}

###############################################################################
# Variables - Security Groups (bastion)
###############################################################################
variable "bastion_sg_name" {
  description = "Name of the Security Group."
  type        = string
}

variable "bastion_sg_description" {
  description = "Description of the Security Group."
  type        = string
}

variable "bastion_sg_source_cidr_block" {
  description = "Source Ingress CIDR block."
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "bastion_sg_ingress_rules" {
  description = "List of ingress rules to create by name."
  type        = list(string)
  default     = []
}

###############################################################################
# Variables - Bastion Instance Profile
###############################################################################
variable "bastion_role_name" {
  description = "Bastion Role Name."
  type        = string
}

variable "bastion_instance_profile_name" {
  description = "Bastion Instance Profile Name."
  type        = string
}

###############################################################################
# Variables - Bastion
###############################################################################
variable "bastion_name" {
  description = "Bastion Instance Name."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance."
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  default     = null
}

###############################################################################
# Variables - EKS
###############################################################################
variable "eks_sg_name" {
  description = "Name of the Security Group."
  type        = string
}

variable "eks_sg_description" {
  description = "Security Group description."
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string
  default     = "eks-staging-cluster"
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.20"
}

variable "worker_nodes_name" {
  description = "Name of the EKS EC2 worker node."
  type        = string
  default     = "worker-group-1"
}

variable "worker_nodes_instance_type" {
  description = "Instance Type of the EKS EC2 worker node."
  type        = string
  default     = "t2.small"
}

variable "worker_nodes_asg_desired_capacity" {
  description = "Number of the desired capacity for the EKS EC2 worker node."
  type        = number
  default     = 2
}
