variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "go-web-app-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
