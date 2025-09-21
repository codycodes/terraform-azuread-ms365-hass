# Multi-Service Example for MS365 Hass

This example shows how to configure one or multiple Microsoft 365 services.

## Usage

> [!NOTE]
> Ensure you're logged in with `az` or have provider configuration setup for `azuread`
---
> [!TIP]
> If you'd like to provision *all* available services and do not have additional [variables](https://github.com/codycodes/terraform-azuread-ms365-hass/blob/main/variables.tf) to configure, you do not need to use `.tfvars` at all.  
> In this case you can skip 2 & 3 and simply omit the use of `-var-file="ms365.tfvars` on the `terraform apply` step.
---

1. Copy this entire directory to another location
2. Copy `ms365.tfvars.example` to `ms365.tfvars`
3. Modify `ms365.tfvars` with your desired service(s) (all services provisioned by default) and additional configuration (if any)
   * example `ms35.tfvars` creating only the following services:

   ```hcl
   selected_services = [
    "todo",
    "calendar",
    "teams",
   ]
   ```

   * For more info on using `.tfvars`, please see the [docs](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/guides/terraform-vars#example-terraform-tfvars)
4. Run the following commands to deploy and fetch values for auth:

```shell
   terraform init
   terraform apply -var-file="ms365.tfvars"
   terraform output client_id_and_secret
```

**You can now follow the instructions on the [Authentication](https://rogerselwyn.github.io/MS365-ToDo/authentication.html) page of your respective integration(s) to set them up in Home Assistant.**
> [!TIP]
> If any changes are needed after the initial infrastructure apply (e.g. adding to `redirect_uris`, simply run the `terraform apply` command again after updating the relevant `.tf` or `.tfvars` files)
