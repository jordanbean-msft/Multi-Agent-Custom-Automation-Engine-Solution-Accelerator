output "application_insights_id" {
  description = "The ID of the Application Insights resource"
  value       = module.avm-res-insights-component.resource_id
}

output "application_insights_name" {
  description = "The name of the Application Insights resource"
  value       = module.avm-res-insights-component.name
}

output "application_insights_connection_string" {
  description = "The connection string of the Application Insights resource"
  value       = module.avm-res-insights-component.connection_string
}

output "application_insights_instrumentation_key" {
  description = "The instrumentation key of the Application Insights resource"
  value       = module.avm-res-insights-component.instrumentation_key
}
