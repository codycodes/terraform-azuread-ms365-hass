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
  source  = "codycodes/ms365-hass/azuread"
  version = "~>1.0"

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
# this is just an easy way to fetch the example code - you can also directly download the repo as a zip if you prefer
git clone https://github.com/codycodes/terraform-azuread-ms365-hass.git

# choose which template you want to use from the examples directory to a directory of your choosing
cp terraform-azuread-ms365-hass/examples/single_service .

az login # only needs to be run when *not* using Azure Cloud Shell
```

**After downloading the code, please continue with the README on how to deploy: [examples/multi_service/README.md](./examples/multi_service/README.md)**

## FAQ

### How Does Auto-Rotation Work?

This module implements an auto-rotation of the client secret (as they have a maximum expiry of *two years*) while allowing for a defined "grace period" window in which the secret should be considered "rotate-able" (meaning a new one will be generated). From that point forward, the cycle restarts.

The benefit of the grace period is that you get a window in which you can decide *when* you want to perform secret rotation prior to the actual secret expiring.

Here's some ascii showing what the defaults do:

```text
Day 0    Day 365                Day 730
 │         │                      │
 │    [Rotation Window Opens]  [Secret Expires]
 │         │<---- 365 days ---->│
 │<------- 730 days ------------->│
```

> ![IMPORTANT]
> Terraform needs to be executed in order to determine whether the token needs to be rotated and to optionally perform rotation.

### How Can I Remove The Resources Created by Terraform?

To remove, you can simply `cd` to where your Terraform is stored and run `terraform destroy`.
For more info please refer to the [command reference](https://developer.hashicorp.com/terraform/cli/commands/destroy)

Happy Automating! 🤖
