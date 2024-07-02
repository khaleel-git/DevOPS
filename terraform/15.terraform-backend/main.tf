terraform {
  backend "s3" {
    bucket = "tf-state"
    region = "us-east-1"
    key = "terraform-tfstate"
  }
}