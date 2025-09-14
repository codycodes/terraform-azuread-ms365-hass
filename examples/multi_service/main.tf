# Configure Terraform
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

module "ms365_hass_calendar" {
  for_each = var.services

  source  = "codycodes/ms365-hass/azuread"
  version = "~>1.0"

  selected_service = each.key
}
