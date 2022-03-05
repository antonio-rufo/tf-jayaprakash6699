## Summary

Terraform module to create the Bastion Role and Instance Profile.

## Usage

```
module "bastion_instance_profile" {
  source = "./modules/bastion_instance_profile"

  bastion_role_name             = var.bastion_role_name
  bastion_instance_profile_name = var.bastion_instance_profile_name

  tags = local.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_role\_name | Name of the Bastion Role. | `string` | `"Bastion_role"` | no |
| bastion\_instance\_profile\_name| Name of the Bastion Instance Profile. | `string` | `"Bastion_profile"` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_instance\_profile | The name of the instance profile. |
| bastion\_role\_arn | The ARN of the Bastion Role. |
