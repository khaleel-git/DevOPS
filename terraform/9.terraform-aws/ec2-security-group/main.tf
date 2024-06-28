# default security group assigned
# inbound: http, https, ssh

resource "aws_instance" "web" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "aws-linux"
  tags = {
    Name = "terraform_key"
  }
}