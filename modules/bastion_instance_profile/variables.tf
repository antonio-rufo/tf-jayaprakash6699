###############################################################################
# Variables - Bastion IAM
###############################################################################
variable "bastion_role_name" {
  description = "Name of the Bastion Role."
  type        = string
  default     = "Bastion_role"
}

variable "bastion_instance_profile_name" {
  description = "Name of the Bastion Instance Profile."
  type        = string
  default     = "Bastion_profile"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
