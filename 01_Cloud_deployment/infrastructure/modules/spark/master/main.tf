locals {
  environment = replace(terraform.workspace, "cf3-", "")
}
module "spark-master" {
  source = "../../service"
  count = var.provision ? 1 : 0

  compute_node_name                    = var.compute_prefix
  environment                          = local.environment
  domain_name                          = var.domain_name
  image_name                           = var.image_name
  external_zone_id                     = var.external_zone_id
  flavor_name                          = var.flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  extra_networks                       = [var.extra_network]
  number_of_compute_nodes              = var.provision ? 1 : 0
  puppet_env                           = var.puppet_env
  subnet_cidr                          = var.subnet_cidr
  cnames                               = [var.compute_prefix]
  create_secgroup                      = 0
  security_groups                      = ["spark-master-${terraform.workspace}-secgroup"]
}
