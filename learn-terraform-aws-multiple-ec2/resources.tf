resource "aws_instance" "app_server" {
  # ami = "ami-083602cee93914c0c" # kernel 4.14
  ami = "ami-08e4e35cccc6189f4" # kernel 5.10
  instance_type = "t2.micro"
  # count = 5

  tags = {
    # Name = "ExampleAppServerInstance"
    Name = var.instance_name # Also you can use this command: terraform apply -var "instance_name=YetAnotherName"
  }
}