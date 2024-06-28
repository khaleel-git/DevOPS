resource "aws_key_pair" "terraform_key" {
  key_name   = "mykeytf"
  public_key = file("/home/khaleel/.ssh/aws_rsa.pub")
}

resource "aws_security_group" "terraformsecuritygroup" {
  name        = "mysecuritygrouptf"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306, 27017]
    iterator = port
    content {
      description = "Dynamically generated security group"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  
}

resource "aws_instance" "newvm" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  tags = {
    Name = "myvmtf"
  }
}
