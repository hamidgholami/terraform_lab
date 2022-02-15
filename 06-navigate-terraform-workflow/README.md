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
    - Working in **branches** enables team members to resolve mutually incompatible infrastructure changes using their normal merge conflict workflow.
    - As the team and the infrastructure grows, so does the number of <ins>sensitive input variables</ins> (e.g. API Keys, SSL Cert Pairs) *required* to run a plan.
    - For resolving previus challenge it's common for teams to **migrate** to a model in which Terraform operations are executed <br /> in <ins>a shared **C**ontinuous **I**ntegration (**CI**) environment</ins>.
    > ### Running Terraform in Automation
    >When running Terraform in automation, the focus is usually on the core plan/>apply cycle. The main path, then, is broadly the same as for CLI usage:
    >
    >Initialize the Terraform working directory.
    >Produce a plan for changing resources to match the current configuration.
    >Have a human operator review that plan, to ensure it is acceptable.
    >Apply the changes described by the plan.
    >
    >Steps 1, 2 and 4 can be carried out using the familiar Terraform CLI commands, >with some additional options:
    >
    >terraform init -input=false to initialize the working directory.
    >terraform plan -out=tfplan -input=false to create a plan and save it to the local >file tfplan.
    >terraform apply -input=false tfplan to apply the plan stored in the file tfplan.

    ### Plan

    ### Apply



### The Core Workflow Enhanced by Terraform Cloud
