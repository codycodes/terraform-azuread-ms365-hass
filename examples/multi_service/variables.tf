variable "services" {
  type        = set(string)
  description = "Services to select for application configuration (todo, mail, calendar, teams, contacts)"
  default = [
    "todo",
    "mail",
    "calendar",
    "teams",
    "contacts",
  ]
}
variable "tenant_id" {
  type        = string
  description = "Tenant / Directory to create resources in"
  default     = null
}
