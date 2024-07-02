terraform {
  backend "s3" {
    bucket = "lenovo-tf-state"
    region = "us-east-1"
    key = "terraform-tfstate"
  }
}