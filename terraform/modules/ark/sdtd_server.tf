resource "sakuracloud_server" "sdtd" {
  name        = "sdtd"
  description = "sdtd` server"

  core           = 4
  memory         = 8
  commitment     = "standard"
  force_shutdown = false

  interface_driver = "virtio"
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.sdtd.id
  }

  disks = [sakuracloud_disk.sdtd.id]
  disk_edit_parameter {
    disable_pw_auth = true
    ssh_keys        = ["ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNRT+L4P7x/bM3S1nNUtEMyfUehoJ669GfZu0W1RbBF/Rlai16uHkoVxvFYP5Lb5LNWPCMdwKJWG3RNtD6Gd+ak="]
    note {
      id = sakuracloud_note.sdtd.id
      variables = {
        sdtd_server_password = var.sdtd_server_password
      }
    }
  }

  tags = ["sdtd"]
}

## Network

resource "sakuracloud_packet_filter" "sdtd" {
  name        = "sdtd-packet-filter"
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

  ## sdtd用ポート

  expression {
    protocol         = "tcp"
    destination_port = "26900"
    description      = "sdtd port"
  }

  expression {
    protocol         = "udp"
    destination_port = "26900-26903"
    description      = "sdtd port"
  }

  expression {
    protocol         = "udp"
    destination_port = "27015"
    description      = "sdtd port"
  }

  expression {
    protocol         = "udp"
    destination_port = "27020"
    description      = "sdtd port"
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

resource "sakuracloud_disk" "sdtd" {
  name              = "sdtd-root"
  connector         = "virtio"
  plan              = "ssd"
  size              = 40
  zone              = "tk1a"
  source_archive_id = data.sakuracloud_archive.ubuntu.id

  tags = ["sdtd"]

  lifecycle {
    ignore_changes = [
      source_archive_id
    ]
  }
}

## Script

resource "sakuracloud_note" "sdtd" {
  name    = "sdtd-server-init"
  content = file("${path.module}/scripts/sdtd_init.sh")
}
