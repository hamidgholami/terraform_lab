### Terraform for generating multiple aws ec2 instances

```sh
terraform destroy -var-file=dev.tfvars
```

```sh
terraform plan -var-file=dev.tfvars -out devtfplan.out
#
terraform apply "devtfplan.out"
```