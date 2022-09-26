resource "lxd_storage_pool" "rbkr" {
  name = "rbkr-pool"
  driver = "zfs"
  config = {
    size = "10GB"
  }
}

resource "lxd_volume" "vol1" {
  name = "rbkr-vol1"
  pool = lxd_storage_pool.rbkr.name
}

resource "lxd_volume" "vol2" {
  name = "rbkr-vol2"
  pool = lxd_storage_pool.rbkr.name
}

locals {
  cloud-init-config = <<EOF
#cloud-config
disable_root: 0
ssh_authorized_keys:
  - ${file("config/id_rsa.pub")}
package_upgrade: true
packages:
  - git
  - nginx
timezone: Africa/Johannesburg
runcmd:
  - touch /tmp/hello.txt
EOF
}

resource "lxd_cached_image" "focal" {
  source_remote = "ubuntu"
  source_image  = "20.04"
}

resource "lxd_container" "test" {
  name        = "test-container"
  image       = lxd_cached_image.focal.fingerprint
  profiles    = ["default"]
  ephemeral   = false

  config = {
    "boot.autostart" = true
    "user.user-data" = local.cloud-init-config
  }

  limits = {
    cpu = 2
  }

  device {
    name = "vol1"
    type = "disk"
    properties = {
      path = "/data"
      source = lxd_volume.vol1.name
      pool = lxd_storage_pool.rbkr.name
    }
  }

  device {
    name = "vol2"
    type = "disk"
    properties = {
      path = "/data2"
      source = lxd_volume.vol2.name
      pool = lxd_storage_pool.rbkr.name
    }
  }

}

