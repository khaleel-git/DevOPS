# resource "aws_instance" "newvm" {
#   ami                    = var.image_id
#   instance_type          = var.instance_type
#   key_name               = aws_key_pair.terraform_key.key_name
#   vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

#   tags = {
#     Name = "newnametflocalprovisioner"
#   }
# }

# output "publicip" {
#   value = aws_instance.newvm.public_ip
# }

data "aws_ami" "ami" {
  most_recent = true
  owners = ["099720109477"]

    filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.ami.id
}