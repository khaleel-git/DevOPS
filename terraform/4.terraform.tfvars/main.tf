output "userage" {
  value = "my name is ${var.username} and my age is ${lookup(var.userage,var.username)}"
}

# terraform plan -var 'usersage={ "gaurav":"23","saurav":"22","men":"25" }'