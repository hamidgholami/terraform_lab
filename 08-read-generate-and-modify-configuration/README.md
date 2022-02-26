# Read generate and modify configuration

- If you're familiar with traditional programming languages, it can be useful to compare Terraform modules to function definitions:
  - Input variables are like function arguments.
  - Output values are like function return values.
  - Local values are like a function's temporary local variables.

### Input variables

  - Each input variable accepted by a module must be declared using a variable block:

      ```tf
      variable "image_id" {
        type = string
      }

      variable "availability_zone_names" {
        type    = list(string)
        default = ["us-west-1a"]
      }

      variable "docker_ports" {
        type = list(object({
          internal = number
          external = number
          protocol = string
        }))
        default = [
          {
            internal = 8300
            external = 8300
            protocol = "tcp"
          }
        ]
      }
      ```
      - The label after the `variable` keyword is a name for the variable, which must be unique among all variables in the same module.
      - The name of a variable can be any valid identifier except the following: `source`, `version`, `providers`, `count`, `for_each`, `lifecycle`, `depends_on`, `locals`.
      
      ### Arguments
      Terraform CLI defines the following optional arguments for variable declarations:

      - `default` - A default value which then makes the variable optional.
      - `type` - This argument specifies what value types are accepted for the variable.
      - `description` - This specifies the input variable's documentation.
      - `validation` - A block to define validation rules, usually in addition to type constraints.
      - `sensitive` - Limits Terraform UI output when the variable is used in configuration.
      - `nullable` - Specify if the variable can be null within the module.
      
      ### Type Constraints
      - The `type` argument in a `variable` block allows you to restrict the type of value that will be accepted as the value for a variable.
      - Type constraints are created from a mixture of type keywords and type constructors. The supported type keywords are:
        - `string`
        - `number`
        - `bool`
      - The type constructors allow you to specify complex types such as collections:
        - `list(<TYPE>)`
        - `set(<TYPE>)`
        - `map(<TYPE>)`
        - `object({<ATTR NAME> = <TYPE>, ... })`
        - `tuple([<TYPE>, ...])`
      - The keyword `any` may be used to indicate that any type is acceptable.
      
      ### Custom Validation Rules
      - In addition to Type Constraints as described above, a module author can specify arbitrary custom validation rules for a particular variable using a `validation` block nested within the corresponding `variable` block:
          
          ```tf
          variable "image_id" {
            type        = string
            description = "The id of the machine image (AMI) to use for the server."

            validation {
              condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
              error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
            }
          }
          ```
      ### Sensitive Data as variable
      - Setting a variable as `sensitive` prevents Terraform from showing its value in the plan or apply output, when you use that variable elsewhere in your configuration.

          ```tf
          variable "user_information" {
            type = object({
              name    = string
              address = string
            })
            sensitive = true
          }

          resource "some_resource" "a" {
            name    = var.user_information.name
            address = var.user_information.address
          }
          ```
### Output Values
- Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use.

### Suppressing Values in CLI Output
- An output can be marked as containing sensitive material using the optional sensitive argument:

    ```tf
    output "db_password" {
      value       = aws_db_instance.db.password
      description = "The password for logging in to the database."
      sensitive   = true
    }
    ```
### Output Value Documentation
- Because the output values of a module are part of its user interface, you can briefly describe the purpose of each value using the optional `description` argument:

    ```tf
    output "instance_ip_addr" {
      value       = aws_instance.server.private_ip
      description = "The private IP address of the main server instance."
    }
    ```
### Explicit Output Dependencies
- Since output values are just a means for passing data out of a module, it is usually not necessary to worry about their relationships with other nodes in the dependency graph.

    ```tf
    output "instance_ip_addr" {
      value       = aws_instance.server.private_ip
      description = "The private IP address of the main server instance."

      depends_on = [
        # Security group rule must be created before this IP address could
        # actually be used, otherwise the services will be unreachable.
        aws_security_group_rule.local_access,
      ]
    }
    ```
- The depends_on argument should be used only as a last resort. When using it, always include a comment explaining why it is being used, to help future maintainers understand the purpose of the additional dependency.