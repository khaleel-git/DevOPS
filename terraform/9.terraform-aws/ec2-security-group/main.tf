resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = file("/home/khaleel/.ssh/aws_rsa.pub")
}

resource "aws_instance" "newvm" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "terraform_key"
  tags = {
    Name = "terraform_key_Attached"
  }
}

resource "aws_security_group" "terraformsecuritygroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  // Ingress rule for SSH (port 22)
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Ingress rule for HTTP (port 80)
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Ingress rule for HTTPS (port 443)
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Ingress rule for MongoDB (port 27017)
  ingress {
    description = "MongoDB from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "keypair" {
  value = aws_key_pair.terraform_key.key_name
}
output "ip" {
  value = aws_instance.newvm.public_ip
}