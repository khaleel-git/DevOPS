#!/bin/bash

# Initialize the Terraform configuration
terraform init

# Validate the Terraform configuration
terraform destroy -auto-approve

# Apply the Terraform configuration with automatic approval
terraform apply -auto-approve