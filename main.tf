# Configure Terraform
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
  }
}

locals {
  permissions = {
    todo = [
      "f45671fb-e0fe-4b4b-be20-3d3ce43f1bcb", # Tasks.Read
      "2219042f-cab5-40cc-b0d2-16b1540b4c5f", # Tasks.Write
    ],
    # todo: mail, calendar, teams
    general = [
      "e1fe6dd8-ba31-4d61-89e7-88639da4683d", # User.Read
      "7427e0e9-2fba-42fe-b0c0-848c9e6a8182", # offline_accesss
    ],
  }
}

resource "azuread_application" "m365_integration" {
  display_name     = "Home Assistant MS365 ${var.selected_service} Integration"
  description      = "Created via Terraform"
  owners           = [] # TODO
  sign_in_audience = var.sign_in_audience
  api {
    requested_access_token_version = 2 # required for some sign_in_audience & recommended due to backwards compat w/v1
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # microsoft graph
    dynamic "resource_access" {
      for_each = concat(local.permissions.general, local.permissions[var.selected_service])
      content {
        id   = resource_access.value
        type = "Scope"
      }
    }
  }
  web {
    redirect_uris = [var.redirect_uri]
  }
  password {
    display_name = "Home Assistant M365"
    start_date   = time_rotating.m365_integration.id
    end_date     = time_rotating.m365_integration.rotation_rfc3339
  }
}

resource "time_rotating" "m365_integration" {
  rotation_days = var.rotation_days
}
