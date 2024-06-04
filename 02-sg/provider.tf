terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "tf-module-testing"
    key    = "expence-dev-sg"       #we can give anything here
    region = "us-east-1"
    dynamodb_table = "tf-module-testing"
}
}

provider "aws" {
  region = "us-east-1"
}
