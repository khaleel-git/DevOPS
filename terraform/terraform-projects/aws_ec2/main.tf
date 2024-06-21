variable "ami" {
  default = "ami-01bc990364452ab3e"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "region" {
  default = "us-east-1"
}

resource "aws_instance" "cerberus" {
  ami           = var.ami
  instance_type = var.instance_type


  user_data              = file("./install-nginx.sh") # it will run at the start of boot (one time only)
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  key_name               = "lasttry"

  tags = {
    Name = "lasttry" # Replace with your desired name
  }
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH access from the Internet"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.cerberus.id
  provisioner "local-exec" {
    command = "echo ${aws_eip.eip.public_dns} >> cerberus_public_dns.txt"
  }

}
output "publicip" {
  value = aws_eip.eip.public_dns
}

