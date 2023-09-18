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

  backend "s3" {
    bucket = "al-ob-gaming-tfstate"
    key    = "ark-server"
    region = "ap-northeast-1"
  }
}

provider "sakuracloud" {
  zone = "tk1a"
}

provider "aws" {
  region = "ap-northeast-1"
}


module "ark-server" {
  source = "../../modules/ark"

  ark_server_password = var.ark_server_password
}
