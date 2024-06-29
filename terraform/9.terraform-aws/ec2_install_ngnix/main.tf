resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

user_data = <<-EOF
#!/bin/bash
ls > ls.txt
sudo apt-get update -y
sudo apt-get install nginx -y
sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html
EOF

  tags = {
    Name = "newnametf"
  }
}

output "publicip" {
  value = aws_instance.newvm.public_ip
}