resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = file("/home/khaleel/.ssh/aws_rsa.pub")
}

resource "aws_instance" "newvm" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = "terraform_key"
  # security_group = aws_security_group.terraformsecuritygroup.id
  tags = {
    Name = "terraform_key_Attached"
  }
}

// Include the security group configuration from security_group.tf
module "my_security_group" {
  source = "./security_group.tf"
}