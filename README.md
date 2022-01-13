# My Terraform Lab
Terraform Labratory

### Note
* For running `terraform apply` or `terraform destroy` commands without the interactive prompt you can use `-auto-approve` as a subcommand.
```bash
terraform apply -auto-approve
# or
terraform destroy -auto-approve
```
* For running Terraform from a different directory than the root module directory, we can use `-chdir=...`
```bash
terraform -chdir=terraform_lab/learn-terraform-aws-instance apply
```