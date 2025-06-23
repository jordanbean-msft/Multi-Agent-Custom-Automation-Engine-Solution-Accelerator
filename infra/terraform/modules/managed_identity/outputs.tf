output "user_assigned_identity_id" {
  description = "The ID of the User Assigned Managed Identity"
  value       = module.avm-res-managedidentity-userassignedidentity.resource_id
}

output "user_assigned_identity_name" {
  description = "The name of the User Assigned Managed Identity"
  value       = module.avm-res-managedidentity-userassignedidentity.resource_name
}

output "user_assigned_identity_client_id" {
  description = "The Client ID of the User Assigned Managed Identity"
  value       = module.avm-res-managedidentity-userassignedidentity.client_id
}

output "user_assigned_identity_principal_id" {
  description = "The Principal ID of the User Assigned Managed Identity"
  value       = module.avm-res-managedidentity-userassignedidentity.principal_id
}
