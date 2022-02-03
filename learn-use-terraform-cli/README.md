# Use the Terraform CLI (outside of core workflow)

### Command: fmt

The terraform fmt command is used to <ins>rewrite Terraform configuration files</ins> to a **canonical format and style**. This command applies a subset of the Terraform language style conventions, along with other minor adjustments for readability.

**Usage and Options**

- It possesses enhancing code readability. (`terraform fmt`)
- Cheking files for formating inconsistencies. (`-check` option)
-  It can to preview the inconsistencies and changes. (`-diff` option) 

**Secnario #1**

Consider `main.tf` file that we have malformed deliberately.

```tf
resource "aws_security_group" "sg_8080" {
  name = "terraform-learn-state-sg-8080"
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
## It's deliberately for to demonstrate how to apply the correct formatting ##
}
}
```

Now we can check which file needs formatting correction by bfollowing command
```bash
[hamid@funlife]$ terraform fmt -check
main.tf
```

We can also use `-diff` option to preview the changes and use `-recursive` to check all sub-directories.

```bash
[hamid@funlife]$ terraform fmt -check -diff -recursive
main.tf
--- old/main.tf
+++ new/main.tf
@@ -55,7 +55,7 @@
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
     ## It's deliberately for to demonstrate how to apply the correct formatting ##
-}
+  }
 }
```

Following command is for applying the proper Terraform format
```bash
[hamid@funlife]$ terraform fmt
# OR 
[hamid@funlife]$ terraform fmt <FILE_NAME>
```

You've now formatted `main.tf` file.

```tf
resource "aws_security_group" "sg_8080" {
  name = "terraform-learn-state-sg-8080"
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ## It's deliberately for to demonstrate how to apply the correct formatting ##
  }
}
```

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