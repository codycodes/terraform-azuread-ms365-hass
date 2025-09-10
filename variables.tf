variable "tenant_id" {
  type = string
}

variable "sign_in_audience" {
  type        = string
  description = <<-EOT
    Controls the types of accounts that can login to the application.
    For more info: https://docs.microsoft.com/en-gb/azure/active-directory/develop/supported-accounts-validation
  EOT
  default     = "AzureADandPersonalMicrosoftAccount"
  validation {
    condition     = !contains(["AzureADMyOrg", "PersonalMicrosoftAccount"], var.sign_in_audience)
    error_message = "var.sign_in_audience value of ${var.sign_in_audience} is not compatible with the M365 custom component integration"
  }
}

variable "selected_service" {
  type        = string
  description = "Service to select for application configuration (todo, mail, calendar, teams, contacts)"
  validation {
    condition     = contains(["todo", "mail", "calendar", "teams", "contacts"], var.selected_service)
    error_message = "selected_service Must be one of (todo, mail, calendar, teams, contacts)"
  }
}

variable "redirect_uri" {
  type        = string
  description = "Configured Azure Cloud used for redirecting to auth with Home Assistant integration"
  default     = "https://login.microsoftonline.com/common/oauth2/nativeclient"
}

variable "rotation_days" {
  type        = number
  description = "Days until secret needs to be recreated. Note: the default of this value is its current maximum value."
  default     = 730
}

variable "rotation_window_days" {
  type        = number
  description = "Days to begin recreating secret within if Terraform is run during this time."
  default     = 365
}

variable "custom_permissions" {
  type        = set(string)
  description = "Custom permissions to use instead of local.permissions"
  default     = null
}

variable "owners" {
  type        = set(string)
  description = "Additional owners for the AzureAD application created"
  default     = []
}
