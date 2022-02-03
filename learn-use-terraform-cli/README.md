# Use the Terraform CLI (outside of core workflow)

## Command: fmt

The terraform fmt command is used to <ins>rewrite Terraform configuration files</ins> to a **canonical format and style**. This command applies a subset of the Terraform language style conventions, along with other minor adjustments for readability.

**Usage and Options**

- It possesses enhancing code readability. (`terraform fmt`)
- Cheking files for formating inconsistencies. (`-check` option)
-  It can to preview the inconsistencies and changes. (`-diff` option) 

**Secnario #1**
Consider `main.tf` file that we have malformed deliberately.

2. `terraform taint`  Replace a resource with CLI
Replacing a resource is also useful in cases where a user manually changes a setting on a resource or when you need to update a provisioning script. This allows you to rebuild specific resources and avoid a full terraform destroy operation on your configuration. The -replace flag allows you to target specific resources and avoid destroying all the resources in your workspace just to fix one of them.

```sh
terraform taint
# OR
terraform plan|apply -replace="<resource>"
```

3. `terraform import`

4. `terraform workspace`

5. `terraform state`

6. debbuging terraform