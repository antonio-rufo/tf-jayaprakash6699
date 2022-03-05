###############################################################################
# Bastion IAM Role
###############################################################################
resource "aws_iam_role" "bastion_role" {
  name = var.bastion_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy_attachment" "AmazonEKSWorkerNodePolicy-attach" {
  name       = "bastion-attachment"
  roles      = [aws_iam_role.bastion_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

###############################################################################
# Bastion Instance Profile
###############################################################################
resource "aws_iam_instance_profile" "bastion_profile" {
  name = var.bastion_instance_profile_name
  role = aws_iam_role.bastion_role.name
}
