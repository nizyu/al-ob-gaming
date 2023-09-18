terraform {
  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.24.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17"
    }
  }
}
