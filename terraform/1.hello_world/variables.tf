# terraform plan -var "username=khaleel"

variable username {}

output printuser {
	value = "Hello ${var.username}"
}

