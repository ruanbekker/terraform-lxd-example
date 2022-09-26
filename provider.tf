terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "1.7.2"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  lxd_remote {
    name     = "my-lxd-host"
    scheme   = "https"
    address  = var.lxd_host
    port     = var.lxd_port
    password = var.lxd_password
    default  = true
  }

}

