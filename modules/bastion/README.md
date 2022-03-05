## Summary

Terraform module to the Bastion Host.

## Usage

```
module "bastion" {
  source = "./modules/bastion"

  bastion_name           = var.bastion_name
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.bastion_security_group.security_group_id]
  user_data              = var.user_data
  iam_instance_profile   = module.bastion_instance_profile.bastion_instance_profile

  tags = local.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_name | Name of the bastion instance. | `string` | n/a | yes |
| ami | AMI to use for the instance. | `string` | n/a | yes |
| instance\_type | The instance type to use for the instance. | `string` | `"t3.micro"` | no |
| key\_name | Key name of the Key Pair to use for the instance. | `string` | n/a | yes |
| subnet\_id | VPC Subnet ID to launch in. | `string` |  n/a | yes |
| vpc\_security\_group\_ids | A list of security group IDs to associate with. | `list(any)` | n/a | yes |
| user\_data | User data to provide when launching the instance. | `string` | `null` | yes |
| iam\_instance\_profile | IAM Instance Profile to launch the instance with. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_ip | The public IP address assigned to the instance. |
