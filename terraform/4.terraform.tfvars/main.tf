output "userage" {
  value = "my name is ${var.username} and my age is ${lookup(var.userage,var.username)}"
}
## below is invalid -> wrong order lookup function arguments
# output "demo" {
#   value = "${lookup(var.username,var.userage)}"
# }

# below line pass map in 
# terraform plan -var 'usersage={ "gaurav":"23","saurav":"22","men":"25" }'