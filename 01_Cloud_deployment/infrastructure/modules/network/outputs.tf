output "network_id" {
  value = element(concat(openstack_networking_network_v2.private_network.*.id, list("")), 0)
}

output "router_id" {
  value = element(concat(openstack_networking_router_v2.router.*.id, list("")), 0)
}

output "subnet_id" {
  value = element(concat(openstack_networking_subnet_v2.private_network_subnet.*.id, list("")), 0)
}
