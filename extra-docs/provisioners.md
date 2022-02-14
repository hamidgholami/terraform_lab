# Provisioners in Terraform

- Provisioners can be used to model specific actions on the **local machine** or on a **remote machine** in order to prepare servers or other infrastructure objects for service.

> NOTE: <br />
> - We <ins>do not recommend</ins> using provisioners for any of the use-cases.
> - Even if your specific use-case is not described in the following sections, <br />we still recommend attempting to solve it <ins>using other techniques first</ins>, and use provisioners only if **there is no other option**

### How to use provisioners

- If you are certain that provisioners are the best way to solve your problem after considering the advice in the sections above, you can add a provisioner block inside the resource block of a compute instance.

  ```tf
  resource "aws_instance" "web" {
    # ...

    provisioner "local-exec" {
      command = "echo The server's IP address is ${self.private_ip}"
    }
  }
  ```
- The `local-exec` provisioner requires no other configuration, but most other provisioners must connect to the remote system using `SSH` or `WinRM`. You must include a connection block so that Terraform will know how to communicate with the server.

  ```tf
  # Copies the file as the root user using SSH
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"

    connection {
      type     = "ssh"
      user     = "root"
      password = "${var.root_password}"
      host     = "${var.host}"
    }
  }

  # Copies the file as the Administrator user using WinRM
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "C:/App/myapp.conf"

    connection {
      type     = "winrm"
      user     = "Administrator"
      password = "${var.admin_password}"
      host     = "${var.host}"
    }
  }
  ```
- All provisioners support the `when` and `on_failure` meta-arguments.

  ```tf
  resource "aws_instance" "web" {
    # ...

    provisioner "local-exec" {
      when    = destroy
      command = "echo 'Destroy-time provisioner'"
    }
  }
  ```

  ```tf
  resource "aws_instance" "web" {
    # ...

    provisioner "local-exec" {
      command    = "echo The server's IP address is ${self.private_ip}"
      on_failure = continue
    }
  }
  ```
### The `self` object

- Expressions in provisioner blocks <ins>cannot refer to their parent resource by name</ins>. Instead, they can use the special `self` object.

- The `self` object represents the provisioner's parent resource, and has all of that resource's attributes. For example, use `self.public_ip` to reference an aws_instance's `public_ip` attribute.

### Multiple Provisioners

- Multiple provisioners can be specified within a resource. Multiple provisioners are executed in the order they're defined in the configuration file.

    ```tf
    resource "aws_instance" "web" {
      # ...

      provisioner "local-exec" {
        command = "echo first"
      }

      provisioner "local-exec" {
        command = "echo second"
      }
    }
    ```

  ### Provisioners Without a Resource

  - If you need to run provisioners that aren't directly associated with a specific resource, you can associate them with a `null_resource`.

  ```tf
  resource "aws_instance" "cluster" {
    count = 3

    # ...
  }

  resource "null_resource" "cluster" {
    # Changes to any instance of the cluster requires re-provisioning
    triggers = {
      cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
    }

    # Bootstrap script can run on any instance of the cluster
    # So we just choose the first in this case
    connection {
      host = "${element(aws_instance.cluster.*.public_ip, 0)}"
    }

    provisioner "remote-exec" {
      # Bootstrap script called with private_ip of each node in the cluster
      inline = [
        "bootstrap-cluster.sh ${join(" ", aws_instance.cluster.*.private_ip)}",
      ]
    }
  }
  ```
### TO DO
<details>
<summary> Preview </summary>

- [ ] trrigers
- [ ] for_each
- [ ] filter

</details>