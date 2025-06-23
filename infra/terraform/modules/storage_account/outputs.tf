output "storage_account_id" {
  value = module.avm-res-storage-storageaccount.resource_id
}

output "storage_account_name" {
  value = module.avm-res-storage-storageaccount.name
}

output "storage_account_primary_blob_endpoint" {
  value = module.avm-res-storage-storageaccount.resource.primary_blob_endpoint
}

output "storage_account_primary_file_endpoint" {
  value = module.avm-res-storage-storageaccount.resource.primary_file_endpoint
}

output "storage_account_primary_queue_endpoint" {
  value = module.avm-res-storage-storageaccount.resource.primary_queue_endpoint
}

output "storage_account_primary_table_endpoint" {
  value = module.avm-res-storage-storageaccount.resource.primary_table_endpoint
}

output "storage_account_primary_web_endpoint" {
  value = module.avm-res-storage-storageaccount.resource.primary_web_endpoint
}
