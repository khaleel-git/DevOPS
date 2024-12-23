resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  # run at boot time (one-time only)
  user_data = file("${path.module}/nginx.sh")
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/khaleel/.ssh/aws_rsa")
  }

  # write public ip to local file
  provisioner "local-exec" {
    working_dir = "/tmp/"
    command     = "echo ${self.public_ip} > public_ip.txt"
  }

  provisioner "local-exec" {
    interpreter = ["/usr/bin/python3", "-c"]
    command     = "print('hello world')"
  }

  provisioner "local-exec" {
    on_failure = continue
    command = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }

  # local-exec at creation of the instance
  provisioner "local-exec" {
    command = "echo 'at Create'"
  }

  # local-exec at deletion of the instance
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'at Delete'"
  }
  tags = {
    Name = "newnametflocalprovisioner"
  }
}

output "publicip" {
  value = aws_instance.newvm.public_ip
}
output "pathmodule" {
  value = "Path module/current path: ${path.module}"
}