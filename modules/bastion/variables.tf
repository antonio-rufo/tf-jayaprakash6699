###############################################################################
# Variables - Bastion
###############################################################################
variable "bastion_name" {
  description = "Name of the bastion instance."
  type        = string
}

variable "ami" {
  description = "AMI to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  default     = "t3.micro"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance."
  type        = string
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = list(any)
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
