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
### Code Structure best practices

- `main.tf` - call modules, locals, and data sources to create all resources
- `variables.tf` - contains declarations of variables used in `main.tf`
- `outputs.tf` - contains outputs from the resources created in `main.tf`
- `versions.tf` - contains version requirements for Terraform and providers