variable "selected_service" {
  type        = string
  description = "Service to select for application configuration (todo, mail, calendar, teams, contacts)"
}
variable "tenant_id" {
  type        = string
  description = "Tenant / Directory to create resources in"
  default     = null
}
