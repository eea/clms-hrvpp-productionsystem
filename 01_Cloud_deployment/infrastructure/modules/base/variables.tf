variable "base_secgroup_rules" {
  type    = map
  default = {
    "ssh"    = { "port" = 22, "remote_ip_prefix" = ["0.0.0.0/0"] }
    "icinga" = { "port" = 5665, "remote_ip_prefix" = ["192.168.20.0/24"] }
  }
}

variable "base_secgroup_rules_any_port" {
  type    = map
  default = {
    "icmp" = { "protocol" = "icmp", "remote_ip_prefix" = ["0.0.0.0/0"] }
  }
}

variable "base_secgroup_rules_range" {
  type    = map
  default = {}
}

variable "dns_nameservers" {
  type    = list(string)
  default = ["185.48.234.234", "185.48.234.238"]
}

variable "environment" {
  type    = string
  default = ""
}

variable "external_network_id" {
  type    = string
  default = ""
}

variable "manage_dns" {
  type    = bool
  default = true
}

variable "manage_network" {
  type    = bool
  default = true
}

variable "manage_secgroup" {
  type    = bool
  default = true
}

variable "network_name" {
  type    = string
  default = ""
}

variable "subnet_cidr" {
  type    = string
  default = ""
}

variable "domain_name" {
  type    = string
  default = "cloud.internal"
}

variable "email" {
  type    = string
  default = "geodatadev@vgt.vito.be"
}
