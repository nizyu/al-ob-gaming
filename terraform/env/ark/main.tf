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

  ark_server_password                   = var.ark_server_password
  discord_application_id                = var.discord_application_id
  discord_bot_access_token              = var.discord_bot_access_token
  discord_public_key                    = var.discord_public_key
  sakuracloud_server_power_token        = var.sakuracloud_server_power_token
  sakuracloud_server_power_token_secret = var.sakuracloud_server_power_token_secret
}


