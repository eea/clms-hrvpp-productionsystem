resource "openstack_compute_keypair_v2" "keypair" {
  name       = "shared-${terraform.workspace}-keypair"
  public_key = chomp(file("${path.module}/id_rsa.pub"))
}

module "network" {
  source = "../network"
  count  = var.manage_network == true ? 1 : 0

  dns_nameservers     = var.dns_nameservers
  external_network_id = var.external_network_id
  network_name        = var.network_name
  subnet_cidr         = var.subnet_cidr
}

module "secgroup" {
  source = "../secgroup"
  count  = var.manage_secgroup ? 1 : 0

  prefix         = "base-${var.environment}"
  rules          = var.base_secgroup_rules
  rules_range    = var.base_secgroup_rules_range
//  rules_any_port = merge({"subnet_cidr"  = { "protocol" = "tcp", "remote_ip_prefix" = [var.subnet_cidr] }}, var.base_secgroup_rules_any_port)
  rules_any_port = var.base_secgroup_rules_any_port
}

module "dns" {
  source = "../dns"
  count  = var.manage_dns == true ? 1 : 0

  zone_name = var.domain_name
  email     = var.email
}
