resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  # run at boot time (one-time only)
  user_data = file("${path.module}/nginx.sh")

  tags = {
    Name = "newnametf"
  }
}

output "publicip" {
  value = aws_instance.newvm.public_ip
}
output "pathmodule" {
  value = "Path module/current path: ${path.module}"
}