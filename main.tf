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
  owners = distinct(concat(
    [data.azuread_client_config.current.object_id],
    tolist(var.owners)
  ))

  permissions = {
    todo = [
      "f45671fb-e0fe-4b4b-be20-3d3ce43f1bcb", # Tasks.Read
      "2219042f-cab5-40cc-b0d2-16b1540b4c5f", # Tasks.Write
    ],
    mail = [
      "570282fd-fa5c-430d-a7fd-fc8dc98a9dca", # Mail.Read
      "7b9103a5-4610-446b-9670-80643382c1fa", # Mail.Read.Shared
      "e383f46e-2787-4529-855e-0e479a3ffac0", # Mail.Send
      "a367ab51-6b49-43bf-a716-a1fb06d2a174", # Mail.Send.Shared
      "818c620a-27a9-40bd-a6a5-d96f7d610b4b", # MailboxSettings.ReadWrite
    ],
    calendar = [
      "465a38f9-76ea-45b9-9f34-9e8b0d4b0b42", # Calendars.Read
      "2b9c4092-424d-4249-948d-b43879977640", # Calendars.Read.Shared
      "662d75ba-a364-42ad-adee-f5f880ea4878", # Calendars.ReadBasic
      "1ec239c2-d7c9-4623-a91a-a9775856bb36", # Calendars.ReadWrite
      "12466101-c9b8-439a-8589-dd09ee67e8e9", # Calendars.ReadWrite.Shared
      "5f8c59db-677d-491f-a6b8-5f174b11ec1d", # Group.Read.All
      "4e46008b-f24c-477d-8fff-7bb4ec7aafe0", # Group.ReadWrite.All
    ],
    teams = [
      "f501c180-9344-439a-bca0-6cbf209fd270", # Chat.Read
      "9ff7295e-131b-4d94-90e1-69fde507ac11", # Chat.ReadWrite
      "76bc735e-aecd-4a1d-8b4c-2b915deabb79", # Presence.Read
      "9c7a330d-35b3-4aa1-963d-cb2b9f927841", # Presence.Read.All
      "8d3c54a7-cf58-4773-bf81-c0cd6ad522bb", # Presence.ReadWrite
      "b340eb25-3456-403f-be2f-af7a0d370277", # User.ReadBasic.All
    ],
    contacts = [
      "ff74d97f-43af-4b68-9f2a-b77ee6968c5d", # Contacts.Read
      "2b9c4092-424d-4249-948d-b43879977640", # Contacts.Read.Shared
    ],
    general = [
      "e1fe6dd8-ba31-4d61-89e7-88639da4683d", # User.Read
      "7427e0e9-2fba-42fe-b0c0-848c9e6a8182", # offline_accesss
    ],
  }
}

data "azuread_client_config" "current" {}

resource "azuread_application" "m365_integration" {
  display_name     = "Home Assistant MS365 ${var.selected_service} Integration"
  description      = "Created via Terraform"
  owners           = local.owners
  sign_in_audience = var.sign_in_audience
  api {
    requested_access_token_version = 2 # required for some sign_in_audience & recommended due to backwards compat w/v1
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # microsoft graph
    dynamic "resource_access" {
      for_each = var.custom_permissions == null ? concat(local.permissions.general, local.permissions[var.selected_service]) : tolist(var.custom_permissions)
      content {
        id   = resource_access.value
        type = "Scope"
      }
    }
  }
  web {
    redirect_uris = [var.redirect_uri]
  }
}

resource "time_rotating" "m365_integration" {
  rotation_days = var.rotation_days
}

locals {
  days_since_password_creation = (timestamp() - time_rotating.m365_integration.unix) / 86400
  refresh_after_days           = var.rotation_days - var.rotation_window_days
}

resource "azuread_application_password" "m365_integration" {
  application_id = azuread_application.m365_integration.id
  display_name   = "Home Assistant M365"
  start_date     = time_rotating.m365_integration.id
  end_date       = time_rotating.m365_integration.rotation_rfc3339

  rotate_when_changed = {
    refresh_trigger = floor(
      local.days_since_password_creation >= local.refresh_after_days
    ) ? "refresh" : "wait"
  }
}
