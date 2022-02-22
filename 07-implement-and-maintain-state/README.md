# Implement and maintain state

- Backends define where Terraform's state snapshots are stored.
- By default, Terraform implicitly uses a backend called `local` to store state as a local file on disk.
    ### Backend Configuration
    - Backends are configured with a nested backend block within the top-level terraform block.
    ```tf
    terraform {
      backend "remote" {
        organization = "example_corp"

        workspaces {
          name = "my-app-prod"
        }
      }
    }
    ```
    - A configuration can only provide one backend block.
    - A backend block cannot refer to named values (like input variables, locals, or data source attributes).
    - There are two types of backend: `local` and `remote`.
    - The local backend stores state on the local filesystem, locks that state using system APIs, and performs operations locally.
    ```tf
    terraform {
      backend "local" {
        path = "relative/path/to/terraform.tfstate"
      }
    }
    ```
    - Data source configuration with `local` backend.
    ```tf
    data "terraform_remote_state" "foo" {
      backend = "local"

      config = {
        path = "${path.module}/../../terraform.tfstate"
      }
    }
    ```
- Some backends act like plain "remote disks" for state files; others support locking the state while operations are being performed, which helps prevent conflicts and inconsistencies.
