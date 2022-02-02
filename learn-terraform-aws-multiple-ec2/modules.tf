module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.4"

  for_each = toset(["1", "2", "3"])

  name = "node-${each.key}"

  ami                    = "ami-08e4e35cccc6189f4"
  instance_type          = "t2.micro"
  # key_name               = "user1"
  # monitoring             = true
  # vpc_security_group_ids = ["sgr-05e5574c8524c407c"]
  # subnet_id              = "subnet-c94fafc8"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}