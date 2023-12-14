lb_create                        = true
lb_floating_ip                   = 1
manage_secgroup                  = true
spark_worker_secgroup_create     = true
manage_dns                       = true
provision_kibana                 = true
provision_elasticsearch          = true
provision_graphite               = true
provision_nifi                   = true
provision_ingest                 = false
provision_spark_history          = true
provision_oscars                 = true
provision_oscars_download        = true
provision_wmts                   = true
provision_web                    = true
provision_vito_tap_vpngateway    = true
provision_spark_vpngateway       = true
oscars_nodes                     = 2
wmts_nodes                       = 2
provision_spark_master_vi        = true
provision_spark_master_ts        = true
provision_spark_master_seed      = true
provision_spark_workers          = false
spark_worker_network_create      = true
vito_tap_vpn_network_create      = true
vito_tap_vpngateway_routes       = {
  "VitoVpnDefault" = { destination_cidr = "172.24.232.0/22"},
  "VitoVpnByodLinux" = { destination_cidr = "172.24.236.0/23"},
  "VitoLan2GebouwTap" = { destination_cidr = "172.24.24.0/24"},
  "VitoLanGebouwTap" = { destination_cidr = "172.24.28.0/24"},
  "VitoVm" = { destination_cidr = "192.168.120.0/22"},
  "IntCvbServ-113" = { destination_cidr = "192.168.113.0/24"},
  "IntCvbServ-201" = { destination_cidr = "192.168.201.0/24"},
  "IntCvbServ-205" = { destination_cidr = "192.168.205.0/24"},
  "IntCvbServ-207" = { destination_cidr = "192.168.207.28/31"},
  "IntDevLan1" = { destination_cidr = "192.168.10.0/24"},
  "IntDevLan2" = { destination_cidr = "192.168.11.0/24"},
  "IntProdLan1" = { destination_cidr = "192.168.20.0/24"},
  "IntProdLan2" = { destination_cidr = "192.168.21.0/24"},
  "DevDmzPub" = { destination_cidr = "193.191.168.0/27"},
  "ProdDmzPub" = { destination_cidr = "193.191.168.128/26"},
  "VLAN1" = { destination_cidr = "193.191.168.32/27"},
  "VLAN2" = { destination_cidr = "193.191.168.64/27"},
  "VLAN3" = { destination_cidr = "193.191.168.96/27"}
}
