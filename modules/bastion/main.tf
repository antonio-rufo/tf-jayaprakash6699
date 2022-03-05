###############################################################################
# Bastion
###############################################################################
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data_base64       = base64encode(var.user_data)
  iam_instance_profile   = var.iam_instance_profile

  tags = merge(
    var.tags,
    { Name = var.bastion_name }
  )
}
