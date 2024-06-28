resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = file("/home/khaleel/.ssh/aws_rsa.pub")
}