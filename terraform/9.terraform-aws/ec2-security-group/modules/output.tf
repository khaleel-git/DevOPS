output "keypair" {
  value = aws_key_pair.terraform_key.key_name
}
output "ip" {
  value = aws_instance.newvm.public_ip
}