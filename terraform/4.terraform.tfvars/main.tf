output "userage" {
  value = "my name is ${var.username} and my age is ${lookup(var.userage,var.username)}"
}

output "demo" {
  value = "${lookup(var.username)}"
}

# terraform plan -var 'usersage={ "gaurav":"23","saurav":"22","men":"25" }'