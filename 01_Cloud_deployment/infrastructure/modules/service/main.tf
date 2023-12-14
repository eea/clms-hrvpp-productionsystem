module "compute_nodes" {
  source = "../compute"

  compute_node_name                    = var.compute_node_name
  environment                          = var.environment
  domain_name                          = var.domain_name
  flavor_name                          = var.flavor_name
  image_name                           = var.image_name
  key_pair                             = "shared-${terraform.workspace}-keypair"
  network_id                           = var.network_id
  network_name                         = var.network_name
  extra_networks                       = var.extra_networks
  number_of_compute_nodes              = var.number_of_compute_nodes
  puppet_env                           = var.puppet_env
  security_groups                      = var.security_groups
  ssh_user                             = var.ssh_user
  extra_volume                         = var.extra_volume
  volume_size                          = var.volume_size
  volume_type                          = var.volume_type
  powered_off                          = var.powered_off
}

module "secgroup" {
  source = "../secgroup"

  count          = var.create_secgroup
  prefix         = var.secgroup_prefix
  rules          = var.rules
  rules_any_port = var.rules_any_port
  rules_range    = var.rules_range
}

module "dns_record" {
  source = "../dns/record"

  count            = var.create_dns ? var.number_of_compute_nodes : 0
  record_name      = "${var.compute_node_name}-${count.index+1}.${var.domain_name}"
  records          = [module.compute_nodes.private_ip[count.index]]
  external_zone_id = var.external_zone_id
}

module "cnames_dns_record" {
  source = "../dns/record"

  count            = length(var.cnames)
  record_name      = "${var.cnames[count.index]}.${var.domain_name}"
  records          = module.compute_nodes.private_ip
  external_zone_id = var.external_zone_id
}
