provider "aws" {
  version = "2.35.0"
}

terraform {
  backend "s3" {
    bucket = "metosin-terraform"
    key = "backend.tfstate"
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "metosin-terraform"
    key    = "common.tfstate"
  }
}

data "terraform_remote_state" "ci" {
  backend = "s3"
  config = {
    bucket = "metosin-terraform"
    key    = "ci.tfstate"
  }
}
