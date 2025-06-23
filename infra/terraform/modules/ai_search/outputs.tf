output "ai_search_id" {
  description = "The ID of the Azure AI Search service"
  value       = module.avm-res-search-searchservice.resource_id
}

output "ai_search_name" {
  description = "The name of the Azure AI Search service"
  value       = module.avm-res-search-searchservice.resource.name
}
