output "client_id" {
  value = azuread_application.m365_integration.client_id
}

output "client_secret" {
  sensitive = true
  value     = azuread_application.m365_integration.password[*].value
}

output "disclaimer" {
  value = "please run 'terraform output client_secret' to fetch its value"
}
