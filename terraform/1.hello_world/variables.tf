# terraform plan -var "username=khaleel"

variable username {
	default = "defaultuser"
}

output printuser {
	value = "Hello ${var.username}"
}

