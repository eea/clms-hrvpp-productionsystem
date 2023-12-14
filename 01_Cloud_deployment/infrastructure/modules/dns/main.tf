resource "openstack_dns_zone_v2" "external_zone" {
  name        = "${var.zone_name}."
  description = "Zone for forwarding from internal DNS"
  ttl         = 300
  type        = "PRIMARY"
  email       = var.email
}
