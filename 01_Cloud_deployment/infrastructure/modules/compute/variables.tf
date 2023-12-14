variable "compute_node_name" { type = string }
variable "environment"       { type = string }
variable "domain_name"       { type = string }
variable "flavor_name"       { type = string }
variable "image_name"        { type = string }
variable "key_pair"          { type = string }
variable "network_id"        { type = string }
variable "network_name"      { type = string }
variable "ssh_user"          { type = string }

variable "extra_networks" {
  type    = list(string)
  default = []
}

variable "number_of_compute_nodes" {
  type    = number
  default = 0
}

variable "puppet_env" {
  type    = string
  default = ""
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "extra_volume" {
  type = bool
  default = false
}

variable "volume_size" {
  type    = number
  default = 50
}

variable "volume_type" {
  type    = string
  default = "HDD"
}

variable "powered_off" {
  type    = list(string)
  default = []
}
