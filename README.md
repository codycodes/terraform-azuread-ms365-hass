# terraform-azuread-ms365-hass

> Infrastructure as Code for @RogerSelwyn's MS365 Home Assistant integrations - deploy from Azure Cloud Shell or locally!

This Terraform module automates the Azure AD application registration and configuration required for Roger Selwyn's comprehensive Microsoft 365 Home Assistant integration suite, eliminating manual setup complexity and enabling reproducible deployments.

> [!NOTE] Cost Disclaimer
> This module creates Azure AD resources that may incur costs depending on your Azure subscription and licensing. While Azure AD Basic features are typically included with most subscriptions, premium features, API call volumes, or specific tenant configurations might result in charges.
> 
> **The maintainers of this module are not responsible for any Azure costs incurred by using this Terraform configuration.** Please review your Azure subscription billing and Azure AD pricing before deployment. Monitor your Azure consumption through the Azure portal.

✨ Features

- ⚡ **Minimal Setup** - Single `selected_service` parameter configures appropriate permissions automatically
- 🚀 **Multiple Deployment Options** - Deploy directly from Azure Cloud Shell with zero local installations or do it locally for free
- 🔄 **Automatic Secret Rotation** - Built-in credential rotation with configurable windows
- 🔍 **Transparent Configuration** - All permissions and settings clearly documented with Microsoft Graph IDs
- 🎯 **Service-Specific Apps** - Creates focused applications per MS365 integration (calendar, mail, todo, teams, contacts) that can be managed from a single command!
- 🔧 **Customizable Inputs** - Override default permissions with custom Microsoft Graph scopes or set additional Owners for the AzureAD app

## Quick Start

### Basic Usage

```hcl
module "ms365_hass_calendar" {
  source = "codycodes/ms365-hass/azuread"
  
  tenant_id        = "your-tenant-id"
  selected_service = "calendar"
}
```

Please see the [examples](./examples) folder for more configurations.

### Setup

You can choose to set this up in either Azure Cloud Shell (easiest, but may have associated cloud cost) or by downloading the tools and running them from your machine (free).

#### Option 1: Azure Cloud Shell

**Pros:** No software installation, always up-to-date tools, integrated authentication
**Cons:** Minimal storage costs for Cloud Shell usage (~$1-2/month typical)

Start by clicking this button or link to [Azure Cloud Shell](https://shell.azure.com)

[![Launch Azure Cloud Shell](https://docs.microsoft.com/azure/includes/media/cloud-shell-try-it/hdi-launch-cloud-shell.png)](https://shell.azure.com)


**Continue with [Shared Setup Steps](#shared-setup-steps) below**

#### Option 2: Locally Installed (free)

<!-- TODO -->
* terraform
* az
* git (not needed but helpful)


#### Shared Setup Steps

```shell
git clone https://github.com/codycodes/terraform-azuread-ms365-hass.git


# choose which template you want to use from the examples directory to a directory of your choosing
cp terraform-azuread-ms365-hass/examples/single_service .

az login # only needs to be run when *not* using Azure Cloud Shell

# this command will fetch the Tenant ID, which is needed for the Terraform azuread provider and used in the next step
az account show --query tenantId -o tsv
```

Create a new file and add the following to it (updating selected_service if needed):

```hcl
tenant_id        = "tenant-id-from-az-command"
selected_service = "todo"
```

Save the file as `ms365.tfvars`

After confirming, run the following command to create your infra:

```shell
terraform apply -var-file="ms365.tfvars" -auto-approve
```

To fetch the client secret you can run:

```shell
terraform output client_secret
```

You can now follow the instructions on the [Authentication](https://rogerselwyn.github.io/MS365-ToDo/authentication.html) page of your respective integration(s) to set them up in Home Assistant. Happy Automating! 🤖
