resource "aws_instance" "web" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2"
}