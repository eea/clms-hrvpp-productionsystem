variable "network_id"               { type = string }
variable "network_name"             { type = string }
variable "puppet_env"               { type = string }
variable "flavor_name"              { type = string }
variable "image_name"               { type = string }
variable "subnet_cidr"              { type = string }
variable "spark_worker_subnet_cidr" { type = string }
variable "domain_name"              { type = string }
variable "external_zone_id"         { type = string }

variable "provision" {
  type    = bool
  default = false
}

variable "create_dns" {
  type    = bool
  default = true
}

variable "number_of_compute_nodes" {
  type    = number
  default = 0
}
variable "compute_prefix" {
  type    = string
  default = "spark-worker"
}

variable "extra_networks" {
  type    = list(string)
  default = ["eodata"]
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

variable "powered_off" {
  type    = list(string)
  default = []
}
