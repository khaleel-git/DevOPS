resource "aws_instance" "newvm" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.terraformsecuritygroup.id] // Use security group ID from the module

  tags = {
    Name = "myvmtf"
  }
}
