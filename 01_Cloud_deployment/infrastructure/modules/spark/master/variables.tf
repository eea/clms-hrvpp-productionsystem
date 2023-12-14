variable "network_id"               { type = string }
variable "network_name"             { type = string }
variable "puppet_env"               { type = string }
variable "flavor_name"              { type = string }
variable "subnet_cidr"              { type = string }
variable "spark_worker_subnet_cidr" { type = string }
variable "domain_name"              { type = string }
variable "external_zone_id"         { type = string }
variable "image_name"               { type = string }
variable "extra_network"            { type = string }

variable "provision" {
  type    = bool
  default = false
}

variable "compute_prefix" {
  type    = string
  default = "spark-master"
}
