# Resource Group Outputs

output "resource_group_name" {
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  value       = module.resource_group.resource_group_location
}

output "resource_group_id" {
  value       = module.resource_group.resource_group_id
}

# Virtual Network Outputs

output "virtual_network_name" {
  value       = module.virtual_network.virtual_network_name
}

output "virtual_network_address_space" {
  value       = module.virtual_network.virtual_network_address_space
}

output "virtual_network_id" {
  value       = module.virtual_network.virtual_network_id
}
