output "client_id_and_secret" {
  sensitive = true
  value     = { for name, instance in module.ms365_hass : name => { client_id = instance.client_id, client_secret = instance.client_secret } }
}

output "disclaimer" {
  value = "please run 'terraform output client_id_and_secret' to fetch its value"
}
