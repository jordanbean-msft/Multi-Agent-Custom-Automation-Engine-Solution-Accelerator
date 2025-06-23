output "log_analytics_workspace_resource_id" {
  value = module.avm-res-operationalinsights-workspace.resource_id
}

output "log_analytics_workspace_customer_id" {
  value = module.avm-res-operationalinsights-workspace.resource.workspace_id
}

output "log_analytics_workspace_primary_shared_key" {
  value     = module.avm-res-operationalinsights-workspace.resource.primary_shared_key
  sensitive = true
}
