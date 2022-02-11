# Interact with Terraform modules


### Difficulties in using complex Terraform configurations

- Understanding and navigating the configuration files will <ins>become increasingly difficult.</ins>
- Updating the configuration will become **more risky**, as an **update to one section** may cause unintended consequences to **other parts** of your configuration.
- There will be an **increasing amount of duplication** of similar blocks of configuration, for instance when configuring separate<br> dev/staging/production environments, which will cause an increasing burden when updating those parts of your configuration.
- You may wish to share parts of your configuration between projects and teams, and will quickly find that cutting and pasting blocks of configuration between projects is **error prone and hard to maintain.**

### What are modules for?

- **Organize configuration** - Modules make it easier to navigate, understand, and update your configuration by keeping related parts of your configuration together. By using modules, you can <ins>organize your configuration</ins> into *logical components*.
- **Encapsulate configuration** - Encapsulation can help <ins>prevent unintended consequences</ins>, such as a *change to one part* of your configuration accidentally causing changes to other infrastructure, and reduce the chances of simple errors like using<br> the <ins>same name for two different resources.</ins>
- **Re-use configuration** - Writing all of your configuration *from scratch* can *be time consuming* and *error prone*. Using modules can *save time* and *reduce costly errors* by *re-using configuration*.
- **Provide consistency and ensure best practices** -  Not only does consistency *make complex configurations easier* to understand, it also helps to ensure that *best practices are applied* across all of your configuration.

### What is a Terraform module?

- A Terraform module is a set of *Terraform configuration files* in *a single directory*. When you run Terraform commands directly from such a directory, it is considered the **root module**.

### Calling modules | Local and remote modules

- A module that is called by another configuration is sometimes referred to as a "**child module**" of that configuration.
- Modules can either be loaded from the **local filesystem**, or a **remote source**. and it supports:
  - Terraform Registry
  - Most version controls
  - HTTP URLs
  - Terraform Cloud
  - . . .

### Module best practices

- Name your provider `terraform-<PROVIDER>-<NAME>`. You must follow this convention in order to publish to the Terraform Cloud.
- Start writing your configuration with modules in mind.
- Use the public Terraform Registry to find useful modules.
- Publish and share modules with your team.

### Use Modules from the Registry

- You can use modules from [the Terraform Registry](https://registry.terraform.io/).
- When calling a module, the `source` argument is <ins>**required**</ins>.
- The other argument is the `version`. For supported sources, the version will let you define *which version or versions* of the module *will be loaded*.

### Define root input variables

- A common pattern is to identify which module **input variables** you might want to change in the future, and create matching variables in your configuration's `variables.tf` file with sensible default values. Those variables can then be passed to the module block as arguments.


### Define root output values

- Modules also have output values, which are defined within the module with the `output` keyword. You can access them by referring to `module.<MODULE NAME>.<OUTPUT NAME>`. Module outputs are listed under the outputs tab in the Terraform registry.

###  Understand how modules work

- When either of these commands are run, Terraform will install any new modules in the `.terraform/modules` directory within your configuration's working directory. For local modules, Terraform will create a `symlink` to the module's directory.

    ```sh
    .
    ├── modules
    │   ├── ec2_instances
    │   ├── modules.json
    │   └── vpc
    └── providers
        └── registry.terraform.io
    ```
### Difference between `variable.tf` and `*.tfvars`

- The `variables.tf` just <ins>defines valid variables</ins> for your templates. The `tfvars` file <ins>declares</ins> them thus giving those variables values.
- The `tfvars` file extension is in the **root folder** of an environment to define values to variables, and the `.tf` uses modules to declare them.
- In the `variables.tf`,you define the variables that <ins>must have values</ins> in order for your Terraform code to validate and run. You can also <ins>define **default values** for your variables in this file.</ins>
- The `*.tfvars` contains one or more `variablename=variablevalue` pairs. When Terraform loads this file, it looks for any variables in your Terraform with the name `variablename` and sets their value to be `variablevalue`. <ins>You can't define new variables here</ins>, and can only set the values of existing ones defined in `variables.tf`.

### Add module configuration

- Notice that there is *no provider block* in the module configuration. When Terraform processes a module block, it <ins>will inherit</ins> the provider from the enclosing configuration. Because of this, we recommend that *you do not include provider blocks in modules*.

### Module Creation - Recommended Pattern

-  Terraform modules should use coding best practices such as **clear organization** and the **DRY** ("Don't Repeat Yourself") principle wherever possible.
-  If a module's function or purpose is **hard to explain**, the module is probably too complex.
-  Output as much information as possible from your module MVP even if you do not currently have a use for it. This will make your module more useful for end users.<br> so **Maximize outputs**.
-  Use `terraform.tfvars.example` file.

### Meta-arguments: `for_each` or `count`

-  Sometimes you want to manage **several similar objects** (like a fixed pool of compute instances) without writing a separate block for each one. Terraform has two ways to do this: `count` and `for_each`.
-  The `count` meta-argument accepts a whole **number**, and creates that many instances of the resource or module. 

### Meta-arguments: `depends_on`

- It is a meta tag that allows you to specify dependencies between resources and modules. For example, you can have <ins>a Google cloud instance</ins> that *depends on* <ins>a specific bucket.</ins> Using the `depends_o`n tag allows Terraform to create or destroy resources correctly. When Terraform sees the `depends_on` module, it will **first** create or kill the bucket before performing the actions specified in the instance.

### Meta-arguments: `providers`

- In a module call block, the optional `providers` meta-argument specifies which provider configurations from the parent module will be available inside the child module.
  ```tf
    provider "aws" {
      alias  = "usw1"
      region = "us-west-1"
    }

    provider "aws" {
      alias  = "usw2"
      region = "us-west-2"
    }

    module "tunnel" {
      source    = "./tunnel"
      providers = {
        aws.src = aws.usw1
        aws.dst = aws.usw2
      }
    }
  ```

### Data source

- Data sources provide <ins>dynamic information</ins> about entities that are not managed by the current Terraform and configuration. Variables provide <ins>static information</ins>.
- Data sources in Terraform are used to <ins>get information about resources external to Terraform</ins>, and use them to set up your Terraform resources. For example, a list of IP addresses a cloud provider exposes.