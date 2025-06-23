output "web_site_id" {
  description = "The ID of the Web Site"
  value       = module.avm-res-web-site.resource_id
}

output "web_site_name" {
  description = "The name of the Web Site"
  value       = module.avm-res-web-site.name
}

output "resource_uri" {
  description = "The default hostname of the Web Site"
  value       = module.avm-res-web-site.resource_uri
}
