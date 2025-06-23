output "cosmos_db_account_id" {
  description = "The ID of the Cosmos DB account"
  value       = module.avm-res-documentdb-databaseaccount.resource_id
}

output "cosmos_db_account_name" {
  description = "The name of the Cosmos DB account"
  value       = module.avm-res-documentdb-databaseaccount.name
}

output "cosmos_db_account_document_endpoint" {
  description = "The document endpoint of the Cosmos DB account"
  value       = "https://${module.avm-res-documentdb-databaseaccount.name}.documents.azure.com:443/"
}
