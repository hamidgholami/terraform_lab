locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances+1) : {
        instance_name = "${srv.application_name}-${i}"
        instance_type = srv.instance_type
        subnet_id   = srv.subnet_id
        ami = srv.ami
        security_groups = srv.vpc_security_group_ids
      }
    ]
  ]
}

// We need to Flatten it before using it
locals {
  instances = flatten(local.serverconfig)
}

resource "aws_instance" "web" {

  for_each = {for server in local.instances: server.instance_name =>  server}
  
  ami           = each.value.ami
  instance_type = each.value.instance_type
  vpc_security_group_ids = each.value.security_groups
  user_data = <<EOF
#!/bin/bash
echo "Copying the SSH Key to the remote server"
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfpyfSejIX38iJtkULXgl7nbDMxZw5kMSEyIl0I/LF2VllakkNi9UsG74N3tgZ45FEnzWmjDQLaLUo3GDshNV1q3Fg74HqxDJwlra7BEpGMCa335M4wCT/+loa85vlVnff7t5SrVxjiuvuT/koOMk0KyqO5Qr/Ajr9fky0Xmf8QTHTlKlrqJ6X/RLoOASniXNssfho0kOZB3TyCThbg2YB32yB/06da46wCzk0rS2PS9EUbSrBBOSuOElEuJG4qZuX+Yr5G9txRn3QJhLK8Oa5JUJAEb2SuAznuwRtz9QmtGOrfudAJPrVOdUaeNMyKegDCwMk5pLNeW1hi03CR17Us6bbDR09G/Pk2pRpKejTLIv3S7zC2RKDcwFEnOuvL36RpIdXGOamPFqNP5ZELg+mJswWxHvkYzYusjDA7o6WLQt5vbR/mVfQVvBYivrjPnCOiLuMVnWUDSWoo4JQF38k7u7TkSCmm28E933Ro8sgEwVmrcuwey2cpiR9JtnjZ3U= hamidg@HamidG-947" >> /home/ec2-user/.ssh/authorized_keys

echo "Changing the hostname to ${each.value.instance_name}"
hostname ${each.value.instance_name}
echo "${each.value.instance_name}" > /etc/hostname

EOF
  subnet_id = each.value.subnet_id
  tags = {
    Name = "${each.value.instance_name}"
  }
}
output "instances" {
  value       = "${aws_instance.web}"
  description = "All Machine details"
}