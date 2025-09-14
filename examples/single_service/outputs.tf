output "client_id_and_secret" {
  sensitive = true
  value     = { id = module.ms365_hass.client_id, secret = module.ms365_hass.client_secret }
}

output "disclaimer" {
  value = "please run 'terraform output client_id_and_secret' to fetch its value"
}
