# Define the AWS provider
provider "aws" {
  region = "eu-central-1"
}

# Create the security group
resource "aws_security_group" "terraformsecuritygroup_4" {
  name        = "mysecuritygrouptf_4"
  description = "Allow inbound traffic on specific ports"

  dynamic "ingress" {
    for_each = [21, 22, 80, 443, 3389]
    iterator = port
    content {
      description = "Allow traffic on port ${port.value}"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP range
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mysecuritygrouptf_4"
  }
}

# Define the EC2 instance
resource "aws_instance" "windows_vm_4" {
  ami           = "ami-01f52dc9cb63c603a"
  instance_type = "t3.xlarge"
  key_name      = "windows_vm"

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.terraformsecuritygroup_4.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    iops                  = 3000 
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  private_dns_name_options {
    hostname_type                   = "ip-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
  }

  tags = {
    Name        = "windowsvm"
    Environment = "Production"
    Owner       = "Khaleel"
  }

  timeouts {
    create = "30m" # Increase create timeout for instance initialization
    delete = "15m"
  }

  # Ensure the instance is ready before running the local-exec provisioner
  depends_on = [aws_security_group.terraformsecuritygroup_4]
}

# # Separate copy function (local-exec provisioner)
# resource "null_resource" "copy_germany_directory" {
#   depends_on = [aws_instance.windows_vm_4]

#   provisioner "local-exec" {
#     command = <<EOT
#       # Copy the 'germany' directory to the EC2 instance using scp
#       echo "Copying the 'germany' directory to the EC2 instance..."
#       scp -i /home/khaleel/.ssh/windows_vm.pem -r /home/khaleel/.ssh/windows_vm.pem Administrator@${aws_instance.windows_vm.public_ip}:C:\Users\Administrator\Desktop
#       echo "'germany' directory copied successfully!"
#     EOT
#   }
# }

# Outputs
output "instance_public_ip" {
  value = aws_instance.windows_vm_4.public_ip
}

output "instance_id" {
  value = aws_instance.windows_vm_4.id
}

output "decrypted_password_file" {
  value = "decrypted_password.json"
}

# Output the full command used to retrieve the password
output "get_password_command" {
  value = "aws ec2 get-password-data --instance-id ${aws_instance.windows_vm_4.id} --priv-launch-key /home/khaleel/.ssh/windows_vm.pem"
}

