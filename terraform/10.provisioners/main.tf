resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  # run at boot time (one-time only)
  user_data = file("${path.module}/nginx.sh")

  # run after boot
  provisioner "file" {
    # source      = "${path.module}/nginx.sh"
    content   = "This is a test content"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/khaleel/.ssh/aws_rsa")
    }
  }

  tags = {
    Name = "newnametf"
  }
}

output "publicip" {
  value = aws_instance.newvm.public_ip
}
output "pathmodule" {
  value = "Path module/current path: ${path.module}"
}