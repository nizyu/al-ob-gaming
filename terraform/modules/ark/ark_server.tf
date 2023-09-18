resource "sakuracloud_server" "ark" {
  name        = "ark"
  description = "ARK server"

  core           = 3
  memory         = 8
  commitment     = "standard"
  force_shutdown = false

  interface_driver = "virtio"
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.ark.id
  }

  disks = [sakuracloud_disk.ark.id]
  disk_edit_parameter {
    disable_pw_auth = true
    ssh_keys        = ["ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNRT+L4P7x/bM3S1nNUtEMyfUehoJ669GfZu0W1RbBF/Rlai16uHkoVxvFYP5Lb5LNWPCMdwKJWG3RNtD6Gd+ak="]
    note {
      id = sakuracloud_note.ark.id
      variables = {
        ark_server_password = var.ark_server_password
      }
    }
  }

  tags = ["ARK"]
}

## Network

resource "sakuracloud_packet_filter" "ark" {
  name        = "ark-packet-filter"
  description = "description"

  expression {
    allow            = true
    protocol         = "tcp"
    destination_port = "22"
    description      = "ssh port"
  }

  expression {
    allow    = true
    protocol = "icmp"
  }

  expression {
    allow    = true
    protocol = "fragment"
  }

  ## ARK用ポート

  expression {
    protocol         = "udp"
    destination_port = "7777-7778"
    description      = "ARK port"
  }

  expression {
    protocol         = "udp"
    destination_port = "27015"
    description      = "ARK port"
  }

  expression {
    protocol         = "udp"
    destination_port = "27020"
    description      = "ARK port"
  }

  ## ステートレスフィルタのため通信の戻りを許可

  expression {
    protocol    = "udp"
    source_port = "123"
  }

  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol         = "udp"
    destination_port = "32768-61000"
  }

  ## 明示許可以外は禁止

  expression {
    allow       = false
    protocol    = "ip"
    description = "Deny ALL"
  }
}

## Disk

data "sakuracloud_archive" "ubuntu" {
  os_type = "ubuntu2204"
}

resource "sakuracloud_disk" "ark" {
  name              = "ark-root"
  connector         = "virtio"
  plan              = "ssd"
  size              = 40
  zone              = "tk1a"
  source_archive_id = data.sakuracloud_archive.ubuntu.id

  tags = ["ARK"]
}

## Script

resource "sakuracloud_note" "ark" {
  name    = "ark-server-init"
  content = file("${path.module}/scripts/ark_init.sh")
}
