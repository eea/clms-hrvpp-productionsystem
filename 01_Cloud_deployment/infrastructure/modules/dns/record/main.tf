resource "openstack_dns_recordset_v2" "external_record_name" {
  zone_id = var.external_zone_id
  name    = "${var.record_name}."
  ttl     = 300
  type    = var.record_type
  records = var.records
}
