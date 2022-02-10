# Interact with Terraform modules


### Difficulties in using complex Terraform configurations

- Understanding and navigating the configuration files will <ins>become increasingly difficult.</ins>
- Updating the configuration will become **more risky**, as an **update to one section** may cause unintended consequences to **other parts** of your configuration.
- There will be an **increasing amount of duplication** of similar blocks of configuration, for instance when configuring separate dev/staging/production environments, which will cause an increasing burden when updating those parts of your configuration.
- You may wish to share parts of your configuration between projects and teams, and will quickly find that cutting and pasting blocks of configuration between projects is **error prone and hard to maintain.**

### What are modules for?

- **Organize configuration** - Modules make it easier to navigate, understand, and update your configuration by keeping related parts of your configuration together. By using modules, you can <ins>organize your configuration</ins> into *logical components*.
- **Encapsulate configuration** - Encapsulation can help <ins>prevent unintended consequences</ins>, such as a *change to one part* of your configuration accidentally causing changes to other infrastructure, and reduce the chances of simple errors like using the <ins>same name for two different resources.</ins>
- **Re-use configuration** - 
- **Provide consistency and ensure best practices**