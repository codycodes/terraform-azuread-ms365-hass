# terraform-azuread-ms365-hass

> Infrastructure as Code to assist with setup for @RogerSelwyn's MS365 Home Assistant integrations - deploy from Azure Cloud Shell or locally!


> [!NOTE]
> **Cost Disclaimer**
>
> This module creates Azure AD resources that may incur costs depending on your Azure subscription and licensing. While Azure AD Basic features are typically included with most subscriptions, premium features, API call volumes, or specific tenant configurations might result in charges.
> 
> **The maintainers of this module are not responsible for any Azure costs incurred by using this Terraform configuration.** Please review your Azure subscription billing and Azure AD pricing before deployment. Monitor your Azure consumption through the Azure portal.

## ✨ Features

- ⚡ **Minimal Setup** - Single `selected_service` parameter configures appropriate permissions automatically
- 🚀 **Multiple Deployment Options** - Deploy directly from Azure Cloud Shell with zero local installations or do it locally for free
- 🔄 **Automatic Secret Rotation** - Built-in credential rotation with configurable windows
- 🔍 **Transparent Configuration** - All permissions and settings clearly documented with Microsoft Graph IDs
- 🎯 **Service-Specific Apps** - Creates focused applications per MS365 integration (calendar, mail, todo, teams, contacts) that can be managed from a single command!
- 🔧 **Customizable Inputs** - Add custom redirect URIs as needed, set additional Owners for the AzureAD app, or override default permissions with custom Microsoft Graph scopes entirely

## Quick Start

### Basic Usage

```hcl
module "ms365_hass_calendar" {
  source = "codycodes/ms365-hass/azuread"

  selected_service = "calendar"
}
```

Please see the [examples](./examples) folder for more configurations, or take a look at the [variables](./variables.tf) page to see the inputs supported by this module.

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
Download the following tools and make them accessible to your shell:

- [terraform](https://developer.hashicorp.com/terraform/install) (>= 1.9)
- [az](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- git (helpful, but you could also copy a zip of the files or copy/paste if needed)

Run the following command & follow steps as needed to auth to Azure

> [!NOTE]
> If you are using a sovereign cloud, you may need to run `az cloud set -n NameOfCloud` as referenced [here](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/sovereign-clouds).

```shell
az login
```

#### Shared Setup Steps

```shell
# this is just an easy way to fetch the code to bootstrap using the module - you can also check the examples folder on this repo if you prefer
git clone https://github.com/codycodes/terraform-azuread-ms365-hass.git

# choose which template you want to use from the examples directory to a directory of your choosing
cp terraform-azuread-ms365-hass/examples/single_service .

az login # only needs to be run when *not* using Azure Cloud Shell
```

Create a new file in the same directory and add the following to it (updating `selected_service` if needed):

```hcl
selected_service = "todo"
```

> [!TIP]
> If you wish to configure any other [variables](./variables.tf), the `.tfvars` file is where to do so!

**Save the file as `ms365.tfvars`**

After confirming, run the following commands to create your infra:

```shell
terraform init

terraform apply -var-file="ms365.tfvars" -auto-approve
```

To fetch the client secret you can run:

```shell
terraform output client_secret
```

You can now follow the instructions on the [Authentication](https://rogerselwyn.github.io/MS365-ToDo/authentication.html) page of your respective integration(s) to set them up in Home Assistant.

> [!TIP]
> If any changes are needed (e.g. adding to `redirect_uris`, simply runn the `terraform apply` command again after updating the relevant `.tf` files)

## FAQ

### How About Auto-Rotation?

<!-- TODO -->

Happy Automating! 🤖
