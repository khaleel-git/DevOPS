# default security group assigned
# inbound: http, https, ssh

resource "aws_instance" "newvm" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "terraform_key"
  tags = {
    Name = "terraform_key_Attached"
  }
}