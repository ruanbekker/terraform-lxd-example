# terraform-lxd-example
Terraform with LXD Example: Creates a LXD Container, ZFS Pool, Userdata, etc.

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

Outputs:

ip = "10.119.194.134"
```

## SSH Config

To be able to ssh directly to a guest with its private ip on a remote lxd host, we can make use of `ProxyJump` in ssh config (`~/.ssh/config`):

```bash
# Globals
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30

# LXD Host
Host lxd-host
    User ubuntu
    Hostname lxd-host.mydomain.com
    IdentityFile ~/.ssh/id_rsa

# LXD Containers
Host 10.119.*
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ProxyJump lxd-host
```

We need to ensure that our public key `~/.ssh/id_rsa.pub` is added to our `ubuntu` user's `~/.ssh/authorized_keys` file, and in our `main.tf` user-data, that we supply the public key content in `config/id_rsa.pub`.

Then we should be able to ssh:

```bash
$ ssh 10.119.194.134
Warning: Permanently added 'x.x.x.x' (x) to the list of known hosts.
Warning: Permanently added '10.119.194.134' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-122-generic x86_64)

ubuntu@test1:~$
```
