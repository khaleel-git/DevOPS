terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# configure aws
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA6ODU2JJ4AX4M6WXZ"
  secret_key = "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"
}