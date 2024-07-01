resource "aws_instance" "newvm" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.terraformsecuritygroup.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/khaleel/.ssh/aws_rsa")
  }

  # in-line remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo apt install net-tools",
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello world' > /tmp/hello.txt"
    ]
  }

  # .sh remote-exec
  provisioner "remote-exec" {
    script = "./nginx.sh"
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