provider "aws" {
  version = "2.35.0"
}

terraform {
  backend "s3" {
    bucket = "metosin-terraform"
    key = "backend.tfstate"
  }
}
