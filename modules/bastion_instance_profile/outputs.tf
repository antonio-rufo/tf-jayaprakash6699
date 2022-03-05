###############################################################################
# Bastion IAM  Output
###############################################################################
output "bastion_instance_profile" {
  description = "The name of the instance profile."
  value       = aws_iam_instance_profile.bastion_profile.name
}

output "bastion_role_arn" {
  description = "The ARN of the Bastion Role."
  value       = aws_iam_role.bastion_role.arn
}
