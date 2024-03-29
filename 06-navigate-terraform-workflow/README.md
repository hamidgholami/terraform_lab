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
- The `terraform init` command is used to **initialize a working directory** containing Terraform *configuration files*.
- This command is always safe to run **multiple** times.
- This command <ins>will never delete</ins> your existing configuration or state.

    ### Copy a Source Module
    -  `init` can be run against <ins>an empty directory</ins> with the `-from-module=MODULE-SOURCE` option, in which case <ins>the given module will be copied into the target directory</ins> before any other initialization steps are run.
       -  This special mode of operation supports <ins>two use-cases</ins>:
          -  Given a version control source, it can serve as a shorthand **for checking out** a configuration <ins>from version control</ins> and then initializing the working directory for it.
          -  If the source refers to an example configuration, it can be copied into a local directory to be used as a basis for a new configuration.
    - For routine use it is recommended to check out configuration from version control separately, using the version control system's own commands.
  
  <br />

    > ### Backend
    > - **Backends** define where <ins>Terraform's state snapshots</ins> are stored.
    > - Terraform defaults to using the `local` backend,
    > - We can use `remote` backend for storing Terraform snapshots.

    </br >

    ### Backend Initialization
    - The `-migrate-state` option will attempt to copy *existing state* to the **new backend**.
    - The `-reconfigure` option disregards any existing configuration, **preventing migration** of any existing state.
    - The `-backend-config=...` option can be used for partial backend configuration, in situations where the backend settings are **dynamic or sensitive** and so *cannot be statically specified* in the configuration file.
    - For an instance this is a backend config file (e.g `config.consul.tfbackend`):
        ```tf
        address = "demo.consul.io"
        path    = "example_app/terraform_state"
        scheme  = "https"
        ```
    - And we use `backend` block in `main.tf`.
        ```tf
        terraform {  
            backend "consul" {}
        }
        ```
    ### Child Module Installation

    - During `init`, the configuration is searched for module blocks, and the `source` code for referenced modules is retrieved from the locations given in their `source` arguments.
    - Use `-upgrade` to override this behavior, updating all modules to the latest available source code.

    ### Plugin Installation
    - `terraform init` will automatically find, download, and install the necessary provider plugins.
    - `-get-plugins=false` — Skip plugin installation.
    - `-plugin-dir=PATH` — Force plugin installation to read plugins only from the specified directory.

### Command: validate
- The `terraform validate` command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.
- Validate runs checks that verify whether a configuration is syntactically valid and internally consistent.
- It is safe to run this command automatically, for example as a post-save check in a text editor or as a test step for a **re-usable** module in a **CI** system.
- Validation *requires* **an initialized working directory** with any referenced **plugins** and **modules installed**.
- To initialize a working directory for validation <ins>without accessing any configured backend</ins>, use:
    ```sh
    terraform init -backend=false
    ```
- JSON output format for validate command. Below is an example of that ouput
  
    ```sh
    {
      "format_version": "1.0",
      "valid": false,
      "error_count": 1,
      "warning_count": 0,
      "diagnostics": [
        {
          "severity": "error",
          "summary": "Cycle: aws_security_group.sg_ping, aws_security_group.sg_8080",
          "detail": ""
        }
      ]
    }
    ```
- `valid` (boolean): Summarizes the overall validation result
- `error_count` (number): A zero or positive whole number giving the count of errors Terraform detected.
- `warning_count` (number): A zero or positive whole number giving the count of warnings Terraform detected. 
- `diagnostics` (array of objects): A JSON array of nested objects that each describe an error or warning from Terraform.
- `severity` (string): A string keyword, currently either "error" or "warning", indicating the diagnostic severity.
- `summary` (string): A short description of the nature of the problem that the diagnostic is reporting.
- `detail` (string): An optional additional message giving more detail about the problem.

### Command: plan
- The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.
- By default, when Terraform creates a plan it:
  - Reads the current state of any already-existing remote objects.
  - Compares the current configuration to the prior state.
  - Proposes a set of change actions that should.

- You can use the optional `-out=FILE` option to save the generated plan to a file on disk.

    ### Planning Modes
    - **Destroy mode:** creates a plan whose goal is to *destroy all remote objects* that currently exist, <br />leaving an empty Terraform state. (`-destroy`)
    - **Refresh-only mode:** creates a plan whose goal is only to update the Terraform state. (`-refresh-only`)

    ### Planning Options
    - `-refresh=false` - Disables the default behavior of synchronizing the Terraform state with remote objects before checking for configuration changes. This can make the planning operation **faster**.
    - `-target=ADDRESS` - Instructs Terraform to focus its planning efforts only on resource instances which match the given address and on any objects that those instances depend on.
    - `-var-file=FILENAME` - Sets values for potentially many input variables declared in the root module of the configuration, using definitions from a "`tfvars`" file.
    - `-out=FILENAME` - Writes the generated plan to the given filename in an opaque file format

### Command: apply
- Another way to use `terraform apply` is to pass it the filename of a saved plan file you created earlier with `terraform plan -out=...`, in which case Terraform will apply the changes in the plan without any confirmation prompt.
- We can use `terraform apply -auto-approve` for skipping confirmation prompt.
- `-input=false`  - Mostly it uses in running Terraform in automation.
- Switching working directory with `-chdir`.
  ```sh
  terraform -chdir=environments/production apply
  ```

### Command: destroy
- The `terraform destroy` command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
- `terraform destroy` is just a convenience alias for the following command:

  ```sh
  terraform apply -destroy
  ```
- Also we can create a destroy plan, to see what the effect of destroying would be.

  ```sh
  terraform plan -destroy
  ```