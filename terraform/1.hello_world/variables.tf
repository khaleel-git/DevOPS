# terraform plan -var "username=khaleel"

variable username {
	default = "defaultuser"
}

variable age {
	type = number
	default = 23
}