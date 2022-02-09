# aws_instance.manually-launched:
resource "aws_instance" "manually-launched" {
    ami                                  = "ami-0a8b4cd432b1c3063"

    associate_public_ip_address          = true
    availability_zone                    = "us-east-1d"
    cpu_core_count                       = 1
    cpu_threads_per_core                 = 1
    disable_api_termination              = false
    ebs_optimized                        = false
    get_password_data                    = false
    hibernation                          = false

    instance_initiated_shutdown_behavior = "stop"

    instance_type                        = "t2.micro"
    ipv6_address_count                   = 0
    ipv6_addresses                       = []
    key_name                             = "hid-ec2-tutorial"
    monitoring                           = false
    
    
    private_ip                           = "172.31.81.115"
    
    
    secondary_private_ips                = []
    security_groups                      = [
        "launch-wizard-1",
    ]
    source_dest_check                    = true
    subnet_id                            = "subnet-04310525"
    tags                                 = {
        "Name" = "manually-launched"
        "name" = "manually-launched"
    }
    tags_all                             = {
        "Name" = "manually-launched"
        "name" = "manually-launched"
    }
    tenancy                              = "default"
    vpc_security_group_ids               = [
        "sg-0622a334a7e464c25",
    ]

    capacity_reservation_specification {
        capacity_reservation_preference = "open"
    }

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
        instance_metadata_tags      = "disabled"
    }

    root_block_device {
        delete_on_termination = true
        
        encrypted             = false
        iops                  = 100
        tags                  = {
            "name" = "manually-launched"
        }
        throughput            = 0
        
        volume_size           = 8
        volume_type           = "gp2"
    }

    timeouts {}
}
