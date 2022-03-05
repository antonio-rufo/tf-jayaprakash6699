###############################################################################
# Outputs - Bastion
###############################################################################
output "bastion_ip" {
  description = "The public IP address assigned to the instance."
  value       = aws_instance.bastion.public_ip
}
