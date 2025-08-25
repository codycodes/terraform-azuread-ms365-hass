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
  # TODO: validation for Do not use the following:
  #
  # Accounts in this organizational directory only (xxxxx only - Single tenant)
  # Personal Microsoft accounts only
}

variable "selected_service" {
  type        = string
  description = "Service to select for application configuration (todo, mail, calendar, teams)"
  validation {
    condition     = contains(["todo", "mail", "calendar", "teams"], var.selected_service)
    error_message = "selected_service Must be one of (todo, mail, calendar, teams)"
  }
}

variable "redirect_uri" {
  type        = string
  description = "Configured Azure Cloud used for redirecting to auth with Home Assistant integration"
  default     = "https://login.microsoftonline.com/common/oauth2/nativeclient"
}

variable "rotation_days" {
  type = number
  # TODO: trigger recreate if within half of the time to refresh
  description = "Days until secret needs to be recreated. Note: the default of this value is its current maximum value."
  default     = 730
}
