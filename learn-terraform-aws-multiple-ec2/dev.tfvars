configuration = [
  {
    "application_name" : "master",
    "ami" : "ami-08e4e35cccc6189f4",
    "no_of_instances" : "1",
    "instance_type" : "t2.micro",
    "subnet_id" : "subnet-6c48b620",
    "vpc_security_group_ids" : ["sg-0622a334a7e464c25"]
  },
  {
    "application_name" : "worker",
    "ami" : "ami-08e4e35cccc6189f4",
    "instance_type" : "t2.micro",
    "no_of_instances" : "2"
    "subnet_id" : "subnet-6c48b620"
    "vpc_security_group_ids" : ["sg-0622a334a7e464c25"]
  }
#   ,
#   {
#     "application_name" : "node",
#     "ami" : "ami-08e4e35cccc6189f4",
#     "instance_type" : "t2.micro",
#     "no_of_instances" : "3"
#     "subnet_id" : "subnet-6c48b620"
#     "vpc_security_group_ids" : ["sg-0622a334a7e464c25"]
#   }
  
]