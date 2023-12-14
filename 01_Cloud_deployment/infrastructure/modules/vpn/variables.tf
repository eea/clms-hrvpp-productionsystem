variable "domain_name" { type = string }
variable "environment" { type = string }
variable "image_name"  { type = string }
variable "network_name" { type = string }
variable "external_zone_id" { type = string }

variable "router_id" { type = string }
variable "vpngateway_ip" { type = string }
variable "floating_ip" { type = string }
variable "vpn_router_routes" { type = map }

variable "create_dns" {
  type    = bool
  default = true
}

variable "flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "power_state" {
  type    = string
  default = "active"
}

variable "ssh_user" {
  type    = string
  default = "eouser"
}

variable "compute_node_name" {
  type    = string
  default = "vpngateway"
}

variable "north_of_vpn_router_routes" {
  type    = map
  default = {
    "SparkWorker" = { destination_cidr = "10.151.0.0/16", next_hop = "192.168.151.254" },
    "VitoVpnDefault" = { destination_cidr = "172.24.232.0/22", next_hop = "192.168.151.253" },
    "VitoVpnByodLinux" = { destination_cidr = "172.24.236.0/23", next_hop = "192.168.151.253" },
    "VitoLan2GebouwTap" = { destination_cidr = "172.24.24.0/24", next_hop = "192.168.151.253" },
    "VitoLanGebouwTap" = { destination_cidr = "172.24.28.0/24", next_hop = "192.168.151.253" },
    "VitoVm" = { destination_cidr = "192.168.120.0/22", next_hop = "192.168.151.253" },
    "IntCvbServ-113" = { destination_cidr = "192.168.113.0/24", next_hop = "192.168.151.253" },
    "IntCvbServ-201" = { destination_cidr = "192.168.201.0/24", next_hop = "192.168.151.253" },
    "IntCvbServ-205" = { destination_cidr = "192.168.205.0/24", next_hop = "192.168.151.253" },
    "IntCvbServ-207" = { destination_cidr = "192.168.207.28/31", next_hop = "192.168.151.253" },
    "IntDevLan1" = { destination_cidr = "192.168.10.0/24", next_hop = "192.168.151.253" },
    "IntDevLan2" = { destination_cidr = "192.168.11.0/24", next_hop = "192.168.151.253" },
    "IntProdLan1" = { destination_cidr = "192.168.20.0/24", next_hop = "192.168.151.253" },
    "IntProdLan2" = { destination_cidr = "192.168.21.0/24", next_hop = "192.168.151.253" },
    "DevDmzPub" = { destination_cidr = "193.191.168.0/27", next_hop = "192.168.151.253" },
    "ProdDmzPub" = { destination_cidr = "193.191.168.128/26", next_hop = "192.168.151.253" },
    "VLAN1" = { destination_cidr = "193.191.168.32/27", next_hop = "192.168.151.253" },
    "VLAN2" = { destination_cidr = "193.191.168.64/27", next_hop = "192.168.151.253" },
    "VLAN3" = { destination_cidr = "193.191.168.96/27", next_hop = "192.168.151.253"}
  }
}
