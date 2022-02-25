# Read generate and modify configuration

- If you're familiar with traditional programming languages, it can be useful to compare Terraform modules to function definitions:
  - Input variables are like function arguments.
  - Output values are like function return values.
  - Local values are like a function's temporary local variables.
  
    ### Declaring an Input Variable
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