output "external_zone_id" {
  value = openstack_dns_zone_v2.external_zone.id
}

output "external_zone_name" {
  value = openstack_dns_zone_v2.external_zone.name
}
