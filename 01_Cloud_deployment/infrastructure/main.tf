module "base" {
  source = "./modules/base"

  manage_network  = false
  manage_dns      = var.manage_dns
  manage_secgroup = var.manage_secgroup
  subnet_cidr     = var.subnet_cidr
  domain_name     = var.domain_name
  environment     = element(split("-", terraform.workspace), length(split("-", terraform.workspace))-1)
  secret_path     = "kv/TAP/big_data_services/devops/dias/creodias/"
}

#Had to import this as to not have it change on us
#terraform import openstack_networking_floatingip_v2.spark_vpngateway_floatingip dc318612-b3ec-408b-9788-2bfd59877ed2
resource "openstack_networking_floatingip_v2" "spark_vpngateway_floatingip" {
  count  = var.provision_vito_tap_vpngateway ? 1 : 0
  pool        = "external"
  address     = "64.225.129.143"
  description = "Spark Network VPN Endpoint"
}

module "spark_worker_network" {
  source = "./modules/network"
  count = var.spark_worker_network_create ? 1 : 0

  network_name        = var.spark_worker_network_name
  dns_nameservers     = var.spark_worker_network_dns
  subnet_cidr         = var.spark_worker_subnet_cidr
  external_network_id = var.network_external_id
  create_router       = false
}

module "spark_vpngateway" {
  source           = "./modules/vpn"
  count            = var.provision_spark_vpngateway ? 1 : 0
  domain_name      = var.domain_name
  environment      = replace(terraform.workspace, "cf3-", "")
  external_zone_id = module.base.external_zone_id

  compute_node_name       = "spark_vpngateway"
  vpngateway_ip           = "10.151.255.253"
  floating_ip             = openstack_networking_floatingip_v2.spark_vpngateway_floatingip[0].address
  router_id               = module.spark_worker_network[0].router_id
  network_name            = var.spark_worker_network_name
  vpn_router_routes       = var.spark_vpngateway_routes
  image_name              = var.spark_vpngateway_image
}

#Had to import this as to not have it change on us
resource "openstack_networking_floatingip_v2" "vpngateway_floatingip" {
  count  = var.provision_vito_tap_vpngateway ? 1 : 0
  pool        = "external"
  address     = "64.225.130.200"
  description = "VPN-OPNsense-17281-1"
}

module "vito_tap_vpn_network" {
  source = "./modules/network"
  count = var.vito_tap_vpn_network_create ? 1 : 0

  network_name        = var.network_name
  dns_nameservers     = var.dns_nameservers
  subnet_cidr         = var.subnet_cidr
  external_network_id = var.network_external_id
  create_router       = true
}

module "vito_tap_vpngateway" {
  source           = "./modules/vpn"
  count            = var.provision_vito_tap_vpngateway ? 1 : 0
  domain_name      = var.domain_name
  environment      = replace(terraform.workspace, "cf3-", "")
  external_zone_id = module.base.external_zone_id

  compute_node_name       = "tap_vpngateway"
  vpngateway_ip           = "192.168.151.253"
  floating_ip             = openstack_networking_floatingip_v2.vpngateway_floatingip[0].address
  router_id               = module.vito_tap_vpn_network[0].router_id
  network_name            = var.network_name
  vpn_router_routes       = var.vito_tap_vpngateway_routes
  image_name              = var.vito_tap_vpngateway_image
}

module "lb" {
  source = "./modules/lb"

  create                = var.lb_create
  attach_floating       = var.lb_floating_ip
  floating_ip_pool_name = var.lb_floating_ip_pool_name
  domain_name           = var.domain_name
  external_zone_id      = module.base.external_zone_id
  loadbalancer          = var.lb_name
  network_id            = var.network_id
  pools                 = var.lb_create ? {
    http     = { proto = "HTTP", port = 80, nodes = module.web[*].ip_list }
    http_ssl = { proto = "HTTPS", port = 443, nodes = module.web[*].ip_list }
  } : {}
}

module "elasticsearch" {
  source = "./modules/service"
  count = var.provision_elasticsearch ? 1 : 0

  compute_node_name                    = var.es_compute_node_name
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.es_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = var.es_number_of_nodes
  puppet_env                           = var.puppet_env
  rules                                = {
    "api"                = { "port" = 9200, "remote_ip_prefix" = [var.subnet_cidr, "192.168.201.23/32", "192.168.201.24/32", "192.168.113.0/24", "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
    "node_communication" = { "port" = 9300, "remote_ip_prefix" = [var.subnet_cidr] }
  }
  secgroup_prefix                      = "elasticsearch-${terraform.workspace}"
  security_groups                      = ["elasticsearch-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
  extra_volume                         = true
  volume_size                          = var.es_volume_size
  volume_type                          = var.es_volume_type
}

module "kibana" {
  source = "./modules/service"
  count = var.provision_kibana ? 1 : 0

  compute_node_name                    = "kibana"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.kibana_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = 1
  puppet_env                           = var.puppet_env
  rules                                = {
    "kibana_webui"       = { "port" = 8080, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
    "kibana_webui_ssl"   = { "port" = 443 , "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
    "api"                = { "port" = 9200, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
    "node_communication" = { "port" = 9300, "remote_ip_prefix" = [var.subnet_cidr] }
  }
  secgroup_prefix                      = "kibana-${terraform.workspace}"
  security_groups                      = ["kibana-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

module "ingest" {
  source = "./modules/service"
  count = var.provision_ingest ? 1 : 0

  compute_node_name                    = "ingest"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.ingest_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = 1
  puppet_env                           = var.puppet_env
  rules                                = {
    "webui" = { "port" = 8443, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
  }
  secgroup_prefix                      = "ingest-${terraform.workspace}"
  security_groups                      = ["ingest-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

module "nifi" {
  source = "./modules/service"
  count = var.provision_nifi ? 1 : 0

  compute_node_name                    = "nifi"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.nifi_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = 1
  puppet_env                           = var.puppet_env
  rules                                = {
    "webui" = { "port" = 8443, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
  }
  secgroup_prefix                      = "nifi-${terraform.workspace}"
  security_groups                      = ["nifi-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
  extra_volume                         = true
  volume_size                          = var.nifi_volume_size
  volume_type                          = var.nifi_volume_type
}

module "spark-master-secgroup" {
  source = "./modules/spark/master/secgroup"

  count                    = (var.provision_spark_master_vi == true || var.provision_spark_master_ts == true) ? 1 : 0
  secgroup_prefix          = "spark-master-${terraform.workspace}"
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr

}

module "spark-worker-secgroup" {
  source = "./modules/spark/worker/secgroup"
  count = var.spark_worker_secgroup_create ? 1 : 0

  secgroup_prefix          = join("-", ["spark-worker", element(split("-", terraform.workspace), length(split("-", terraform.workspace))-1)])
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr

}

module "spark-master-vi" {
  source = "./modules/spark/master"

  provision                = var.provision_spark_master_vi
  compute_prefix           = "vi-master"
  domain_name              = var.domain_name
  image_name               = var.image_name
  external_zone_id         = module.base.external_zone_id
  network_id               = var.network_id
  network_name             = var.network_name
  puppet_env               = var.puppet_env
  flavor_name              = var.spark_master_flavor_name
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr
  extra_network            = var.spark_master_vi_extra_network
}

module "spark-master-ts" {
  source = "./modules/spark/master"

  provision                = var.provision_spark_master_ts
  compute_prefix           = "ts-master"
  domain_name              = var.domain_name
  image_name               = var.image_name
  external_zone_id         = module.base.external_zone_id
  network_id               = var.network_id
  network_name             = var.network_name
  puppet_env               = var.puppet_env
  flavor_name              = var.spark_master_flavor_name
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr
  extra_network            = var.spark_master_ts_extra_network
}
module "spark-master-seed" {
  source = "./modules/spark/master"

  provision                = var.provision_spark_master_seed
  compute_prefix           = "seed-master"
  domain_name              = var.domain_name
  image_name               = var.image_name
  external_zone_id         = module.base.external_zone_id
  network_id               = var.network_id
  network_name             = var.network_name
  puppet_env               = var.puppet_env
  flavor_name              = var.spark_master_flavor_name
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr
  extra_network            = var.spark_master_seed_extra_network
}

module "spark-history" {
  source = "./modules/service"
  count = var.provision_spark_history ? 1 : 0

  compute_node_name                    = "spark-history"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.spark-history_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  extra_networks                       = [var.spark-history_extra_network]
  number_of_compute_nodes              = 1
  puppet_env                           = var.puppet_env
  rules                                = {
    "history_ui"     = { "port" = 8080, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
    "history_ui_ssl" = { "port" = 8480, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
  }
  rules_range                          = {
    "intern_traffic" = { "port_range_min" = 0, "port_range_max" = 0, "remote_ip_prefix" = [var.subnet_cidr] }
  }
  secgroup_prefix                      = "spark-history-${terraform.workspace}"
  security_groups                      = ["spark-history-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

module "oscars" {
  source = "./modules/service"
  count = var.provision_oscars ? 1 : 0

  compute_node_name                    = "oscars"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.oscars_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = var.oscars_nodes
  puppet_env                           = var.puppet_env
  rules                                = {
    "api" = { "port" = 8080, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "health" = { "port" = 8081, "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
  secgroup_prefix                      = "oscars-${terraform.workspace}"
  security_groups                      = ["oscars-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

module "oscars-download" {
  source = "./modules/service"
  count = var.provision_oscars_download ? 1 : 0

  compute_node_name                    = "oscars-download"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.oscars_download_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  number_of_compute_nodes              = var.oscars_download_nodes
  puppet_env                           = var.puppet_env
  rules                                = {
    "download" = { "port" = 80, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "packager" = { "port" = 8080, "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
  secgroup_prefix                      = "oscars-download-${terraform.workspace}"
  security_groups                      = ["oscars-download-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

# image_name = "puppet_base_image_centos8-2021-08-19_07-34-28"
module "wmts" {
  source = "./modules/service"
  count = var.provision_wmts ? 1 : 0

  compute_node_name                    = "wmts"
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.wmts_flavor_name
  image_name                           = var.wmts_image
  network_id                           = var.network_id
  network_name                         = var.network_name
  number_of_compute_nodes              = var.wmts_nodes
  puppet_env                           = var.puppet_env
  rules                                = {
    "api"       = { "port" = 8080, "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
  secgroup_prefix                      = "wmts-${terraform.workspace}"
  security_groups                      = ["wmts-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}


module "graphite" {
  source = "./modules/service"
  count = var.provision_graphite ? 1 : 0

  compute_node_name                    = "graphite"
  cnames                               = ["grafana"]
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.graphite_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.graphite_name
  number_of_compute_nodes              = 1
  puppet_env                           = var.mgmt_puppet_env
  rules                                = {
    "web"       = { "port" = 80, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "web_ssl"   = { "port" = 443, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "carbon"    = { "port" = 2003, "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
  secgroup_prefix                      = "graphite-${terraform.workspace}"
  security_groups                      = ["graphite-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
  extra_volume                         = true
  volume_size                          = var.graphite_volume_size
  volume_type                          = var.graphite_volume_type
}

module "web" {
  source = "./modules/service"
  count = var.provision_web ? 1 : 0

  compute_node_name                    = "web"
  number_of_compute_nodes              = var.web_nodes
  environment                          = replace(terraform.workspace, "cf3-", "")
  domain_name                          = var.domain_name
  external_zone_id                     = module.base.external_zone_id
  flavor_name                          = var.web_flavor_name
  network_id                           = var.network_id
  network_name                         = var.network_name
  image_name                           = var.image_name
  puppet_env                           = var.puppet_env
  rules                                = {
    "httpd" = { "port" = 80, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "httpd_ssl" = { "port" = 443, "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
  secgroup_prefix                      = "web-${terraform.workspace}"
  security_groups                      = ["web-${terraform.workspace}-secgroup"]
  subnet_cidr                          = var.subnet_cidr
}

module "spark-worker" {
  source = "./modules/spark/worker"

  provision                = var.provision_spark_workers
  compute_prefix           = join("-", [split("-", replace(terraform.workspace, "cf3-", ""))[0], "worker"])
  number_of_compute_nodes  = var.spark_worker_nodes
  domain_name              = var.domain_name
  external_zone_id         = var.dns_zone_id
  network_id               = length(module.spark_worker_network) > 0 ? module.spark_worker_network[0].network_id : null
  network_name             = var.spark_worker_network_name
  puppet_env               = ""
  flavor_name              = var.spark_worker_flavor_name
  image_name               = var.spark_worker_image_name
  subnet_cidr              = var.subnet_cidr
  spark_worker_subnet_cidr = var.spark_worker_subnet_cidr
  powered_off              = var.spark_worker_nodes_powered_off
  extra_volume             = var.spark_worker_extra_volume
  volume_size              = var.volume_size
  volume_type              = var.volume_type
  extra_networks           = [var.spark_worker_network]
}
