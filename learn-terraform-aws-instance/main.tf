terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami = "ami-083602cee93914c0c" # kernel 4.14
  #   ami           = "ami-08e4e35cccc6189f4" # kernel 5.10
  instance_type = "t2.micro"

  tags = {
    # Name = "ExampleAppServerInstance"
    Name = var.instance_name # Also you can use this command: terraform apply -var "instance_name=YetAnotherName"
  }
}