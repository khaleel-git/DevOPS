// Include the security group module
module "modules" {
  source = "./modules"
}

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