# Multi-Service Example

This example shows how to configure multiple Microsoft 365 services.

## Usage

1. Copy this entire directory to another location
2. Copy `ms365.tfvars.example` to `ms365.tfvars`
3. Modify `terraform.tfvars` with your desired services (all services provisioned by default) and configuration (if any)
   * example `ms35.tfvars` creating only the following services:

   ```hcl
   services = [
    "todo",
    "calendar",
    "teams",
   ]
   ```

   * For more info on using `.tfvars`, please see the [docs](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/guides/terraform-vars#example-terraform-tfvars)
4. Run the following commands to deploy and fetch values for auth:

```shell
   terraform init
   terraform apply -auto-approve -var-file="ms365.tfvars"
   terraform output client_id_and_secret
```

5. You can now follow the instructions on the [Authentication](https://rogerselwyn.github.io/MS365-ToDo/authentication.html) page of your respective integration(s) to set them up in Home Assistant.

> [!TIP]
> If any changes are needed after the initial infrastructure apply (e.g. adding to `redirect_uris`, simply run the `terraform apply` command again after updating the relevant `.tf` or `.tfvars` files)