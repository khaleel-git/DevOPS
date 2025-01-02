variable "project" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
}

variable "zone" {
  description = "The Google Cloud zone"
  type        = string
}

# Add a variable for the username
variable "username" {
  description = "The username to use for RDP access"
  type        = string
}

variable "image" {
  description = "The image to use for the VM"
  type        = string
  
}