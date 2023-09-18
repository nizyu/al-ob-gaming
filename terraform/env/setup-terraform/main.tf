provider "aws" {
  region = "ap-northeast-1"
}

module "setup" {
  source = "../../modules/setup-env"
}

