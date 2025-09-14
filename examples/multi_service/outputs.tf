output "client_id_and_secret" {
  sensitive = true
  value     = { for name, instance in module.ms365_hass : name => { id = instance.client_id, secret = instance.client_secret } }
}

output "disclaimer" {
  value = "please run 'terraform output client_id_and_secret' to fetch its value"
}
