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
    ### State Locking
    - If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.
    - State locking happens automatically on all operations that could write state.
    ### Command: refresh
    - The `terraform refresh` command reads the current settings from all managed remote objects and updates the Terraform state to match.

    ### Sensitive Data in State
    - When using local state, state is stored in plain-text JSON files.
    - When using remote state, state is only ever held in memory when used by Terraform. It may be encrypted at rest, but this depends on the specific remote state backend.
