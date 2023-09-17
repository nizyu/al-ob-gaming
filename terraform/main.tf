
terraform {
  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.24.1"
    }
  }
}

provider "sakuracloud" {
  zone   = "tk1a"
}

