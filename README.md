## Summary

This repo will create a create your custom EKS environment.

## Basic Architecture

![Design](.github/img/tf-jayaprakash6699.png)

## Built with:

* Terraform (v1.0.4)
* AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

### Step by Step deployment
* **Step 1: Clone the Repo**. This command will clone the repo and will change directory the recently cloned repo
```shell script
$ git clone https://github.com/antonio-rufo/tf-jayaprakash6699.git
```


$ vi terraform.tfvars
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

* **Step 2: Create a S3 bucket for remote state storage.** Update the `terraform.tfvars` file with your account ID and region and environment
```shell script
$ cd tf-jayaprakash6699
$ cd statebucket
$ vi terraform.tfvars
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
Take note of the output for `state_bucket_id`. You'll need to update the `main.tf` on each layer with it. It is not yet possible to have the state bucket values interpolated.  


* **Step 3: Create your base layer.** Update the `terraform.tfvars` file with your account ID, region, and environment. Then fill up all required variables. Then update `main.tf` with the **state_bucket_id** created in step 2 (line 10) as well as the **region** (line 12).
```shell script
$ cd ../environment/000base
$ vi terraform.tfvars
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

* **Step 4: Create your compute layer.** Update the `terraform.tfvars` file with your account ID, region, and environment. Then fill up all required variables. Then update `main.tf` with the **state_bucket_id** created in step 2 (line 10) as well as the **region** (line 12).
```shell script
$ cd ../100compute
$ vi terraform.tfvars
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
