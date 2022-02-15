# Navigate Terraform workflow

There are many different ways to use Terraform: 
1. As an individual user 
2. A single team
3. An entire organization at scale. 
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
    - For resolving previous challenge it's common for teams to **migrate** to a model in which **Terraform operations are executed** <br /> in <ins>a shared **C**ontinuous **I**ntegration (**CI**) environment</ins>. We can use `CircleCI`, `Gihub Action`, `Gitlab`, `Jenkins` etc.
  
    <br />

    > ### Running Terraform in Automation
    ><br />
    >When running Terraform in automation, the focus is usually on the core plan/apply cycle. The main path, then, is broadly the same as for CLI usage:
    >
    >1. Initialize the Terraform working directory.
    >2. Produce a plan for changing resources to match the current configuration.
    >3. Have a human operator review that plan, to ensure it is acceptable.
    >4. Apply the changes described by the plan.
    >
    >Steps 1, 2 and 4 can be carried out using the familiar Terraform CLI commands, with some additional options:
    >
    >`terraform init -input=false` to initialize the working directory.<br />
    >`terraform plan -out=tfplan -input=false` to create a plan and save it to the local file `tfplan`.<br />
    >`terraform apply -input=false tfplan` to apply the plan stored in the file `tfplan`.

    ### Plan
    - For teams collaborating on infrastructure, Terraform's plan output creates an opportunity for team members<br /> to **review each other's work**.
    - The natural place for these reviews to occur is alongside **pull requests** within version control.
    - For example, if a team notices that a certain change could result in service *disruption*, they may decide to *delay merging* its pull request until they can *schedule a maintenance window*.

    ### Apply
    - Once a pull request has been approved and merged, it's important for the team to review the final **concrete plan** that's run against the shared team branch and the *latest version of the state file*.
    - Operation team might be asked these questions:
      - Do we expect any service disruption from this change?
      - Is there any part of this change that is high risk?
      - Is there anything in our system that we should be watching as we apply this?
      - Is there anyone we need to notify that this change is happening?
### The Core Workflow Enhanced by Terraform Cloud
-  Terraform Cloud is designed to support and enhance the core Terraform workflow for anyone collaborating on infrastructure, from small teams to large organizations.

### Command: init
- The terraform init command is used to **initialize a working directory** containing Terraform *configuration files*.
- This command is always safe to run **multiple** times.
- This command <ins>will never delete</ins> your existing configuration or state.

    ### Copy a Source Module
    -  `init` can be run against an empty directory with the `-from-module=MODULE-SOURCE` option, in which case the given module will be copied into the target directory before any other initialization steps are run.
