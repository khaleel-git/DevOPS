output "userage" {
  value = "my name is ${var.username} and my age is ${lookup(var.userage,var.username)}"
}

# terraform plan -var-file=custom.tfvars