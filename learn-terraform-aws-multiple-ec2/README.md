### Terraform for generating multiple aws ec2 instances

```sh
terraform init
```

```sh
terraform plan -var-file=dev.tfvars -out devtfplan.out
#
terraform apply "devtfplan.out"
```
```sh
terraform destroy -var-file=dev.tfvars
```