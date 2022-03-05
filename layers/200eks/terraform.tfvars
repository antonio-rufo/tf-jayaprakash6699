###############################################################################
# Environment
###############################################################################
aws_account_id = "XXXXXXXXXXXXXX"
aws_profile    = "XXXXXXXXXXXXXX"
region         = "XXXXXXXXXXXXXX"
environment    = "Development"

###############################################################################
# EKS
###############################################################################
cluster_name = "eks-cluster"

###############################################################################
# Security Groups (Bastion)
###############################################################################
bastion_sg_name              = "bastion-security-group"
bastion_sg_description       = "Accepts SSH from public."
bastion_sg_source_cidr_block = ["0.0.0.0/0"]
bastion_sg_ingress_rules     = ["ssh-tcp"]

###############################################################################
# Bastion Role/Instance Profile
###############################################################################
bastion_role_name             = "Bastion_role"
bastion_instance_profile_name = "Bastion_profile"

###############################################################################
# Bastion
###############################################################################
bastion_name  = "Bastion"
instance_type = "t3.micro"
key_name      = "XXXXXXXXXXXXXX" ### PLEASE UPDATE TO YOUR KEY PAIR
user_data     = <<EOF
#!/bin/bash
yum update -y
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
EOF

###############################################################################
# EKS Worker Nodes SG
###############################################################################
eks_sg_name        = "eks-worker-nodes-security-group"
eks_sg_description = "Accepts traffic from Bastion host"

###############################################################################
# EKS Worker Nodes
###############################################################################
eks_cluster_name                  = "eks-cluster"
eks_cluster_version               = "1.20"
worker_nodes_name                 = "worker-group-eks"
worker_nodes_instance_type        = "t2.small"
worker_nodes_asg_desired_capacity = 2
