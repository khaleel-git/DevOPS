module "web-server" {
  source        = "./modules/web-server"
  instance_type = "t2.micro"
  ports         = [22, 80, 8080, 443, 3306, 27017]
  key_name   = "mykeytf"
  public_key = file("/home/khaleel/.ssh/aws_rsa.pub")
}