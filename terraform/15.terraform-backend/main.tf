terraform {
  backend "s3" {
    bucket = "lenovo-tf-state"
    region = "us-east-1"
    key = "terraform-tfstate"
  }
}
# comment above and run below command of migration of backend
# terraform init -migrate-state

resource "aws_instance" "newvm" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.small"
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  tags = {
    Name = "newnametflocalprovisioner"
  }
}
