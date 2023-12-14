output "network_id" {
  value = var.manage_network == true ? module.network[0].network_id : ""
}

output "router_id" {
  value = var.manage_network == true ? module.network[0].router_id : ""
}

output "subnet_id" {
  value = var.manage_network == true ? module.network[0].subnet_id : ""
}

output "external_zone_id" {
  value = var.manage_dns == true ? module.dns[0].external_zone_id : ""
}
