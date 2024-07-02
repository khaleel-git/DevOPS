module "muimport" {
  source = "../."
}

resource "aws_instance" "newvm" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  tags = {
    Name = "newnametflocalprovisioner"
  }
}

output "aws_ami_id" {
  value = data.aws_ami.ami.id
}

output "public_ip" {
  value = aws_instance.newvm.public_ip
}