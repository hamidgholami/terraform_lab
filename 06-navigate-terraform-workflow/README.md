# Navigate Terraform workflow

### The Core Terraform Workflow
- The core Terraform workflow has three steps:
  1. **Write** - Author infrastructure as code.
  2. **Plan** - Preview changes before applying.
  3. **Apply** - Provision reproducible infrastructure.

### Write
- You write Terraform configuration just like you write code. It's common practice to store your work in a version control.
- repeatedly running `terraform plan` can help flush out syntax errors and ensure that your config is coming together as you expect.

### Plan
- When you make sure about the code and its syntax, you can store it in the version control by commiting it.
- `terraform apply` will display a plan for confirmation before proceeding to change any infrastructure.

### Apply
- After one last check, you are ready to tell Terraform to provision real infrastructure.
- It's common to push your version control repository to a remote location for safekeeping.

### Working as a team
- Once multiple people are collaborating on Terraform configuration, new steps must be added to each part of the core workflow to ensure everyone is working together smoothly.


### Write

### Plan

### Apply

### Running Terraform in Automation

### The Core Workflow Enhanced by Terraform Cloud
