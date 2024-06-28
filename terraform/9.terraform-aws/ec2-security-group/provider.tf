terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAZQ3DPNTPXJTGCRV4"
  secret_key = "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"
}
