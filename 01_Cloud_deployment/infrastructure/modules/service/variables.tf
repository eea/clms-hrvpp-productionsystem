variable "compute_node_name" { type = string }
variable "domain_name"       { type = string }
variable "flavor_name"       { type = string }
variable "environment"       { type = string }
variable "network_id"        { type = string }
variable "network_name"      { type = string }
variable "puppet_env"        { type = string }
variable "subnet_cidr"       { type = string }

variable "cnames" {
  type    = list(string)
  default = []
}

variable "create_dns" {
  type    = bool
  default = true
}

variable "extra_networks" {
  type    = list(string)
  default = []
}

variable "image_name" {
  type    = string
  default = "puppet_base_image"
}
#default = "puppet_base_image-2021-08-19_07-18-13"

variable "number_of_compute_nodes" {
  type    = number
  default = 0
}

variable "create_secgroup" {
  type    = number
  default = 1
}

variable "secgroup_prefix" {
  type    = string
  default = ""
}

variable "rules" {
  type    = map
  default = {}
}

variable "rules_any_port" {
  type    = map
  default = {}
}

variable "rules_range" {
  type    = map
  default = {}
}

variable "security_groups" {
  type    = list
  default = []
}

variable "ssh_user" {
  type = string
  default = "eosuser"
}

variable "extra_volume" {
  type = bool
  default = false
}

variable "volume_size" {
  type    = number
  default = 0
}

variable "volume_type" {
  type    = string
  default = "HDD"
}

variable "external_zone_id" {
  type = string
}

variable "lb_pool_id" {
  type    = string
  default = "no"
}

variable "lb_port" {
  type    = number
  default = 8080
}

variable "powered_off" {
  type    = list(string)
  default = []
}
