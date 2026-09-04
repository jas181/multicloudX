output "azure_network_id" { value = try(module.azure_network[0].vnet_id, null) }
output "aws_vpc_id" { value = try(module.aws_network[0].vpc_id, null) }
output "gcp_network_id" { value = try(module.gcp_network[0].network_id, null) }
