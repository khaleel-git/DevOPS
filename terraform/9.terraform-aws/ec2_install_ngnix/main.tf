resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  tags = {
    Name = "myvmtf"
  }
  user_data = <<EOF
  #!/usr/bin/bash
  sudo apt update -y
  sudo apt install nginx -y
  EOF
}

output "publicip" {
  value = aws_instance.newvm.public_ip
}