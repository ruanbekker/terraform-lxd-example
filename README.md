# terraform-lxd-example
Terraform with LXD Example

## Provider

Using the [terraform-provider-lxd](https://registry.terraform.io/providers/terraform-lxd/lxd/latest/docs) to provision a LXD container.

## Pre-Requisites

You will require a host with LXD and you will also require to initialize the host and setup remote connections:
- https://linuxcontainers.org/lxd/getting-started-cli/

## Terraform

Populate your `lxd_host` and `lxd_password` in `variables.tf` to fit your environment.

Then provision a lxd instance and a zfs storage pool with terraform:

```bash
terraform init
terraform plan
terraform apply
```
