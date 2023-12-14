module "spark-worker" {
  source = "../../service"
  count = var.provision ? 1 : 0

  compute_node_name                    = var.compute_prefix
  create_dns                           = var.create_dns
  number_of_compute_nodes              = var.number_of_compute_nodes
  environment                          = element(split("-", terraform.workspace), length(split("-", terraform.workspace))-1)
  domain_name                          = var.domain_name
  external_zone_id                     = var.external_zone_id
  flavor_name                          = var.flavor_name
  image_name                           = var.image_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  extra_networks                       = var.extra_networks
  puppet_env                           = var.puppet_env
  create_secgroup                      = 0
  security_groups                      = [join("-", ["spark-worker", element(split("-", terraform.workspace), length(split("-", terraform.workspace))-1), "secgroup"])]
  subnet_cidr                          = var.subnet_cidr
  extra_volume                         = var.extra_volume
  volume_size                          = var.volume_size
  volume_type                          = var.volume_type
  powered_off                          = var.powered_off

}
