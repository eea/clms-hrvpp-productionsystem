variable "create" { type = bool }
variable "domain_name" { type = string }
variable "external_zone_id" { type = string }
variable "loadbalancer" { type = string }
variable "network_id" { type = string }
variable "pools" { type = map }

variable "attach_floating" {
  type    = number
  default = 0
}

variable "floating_ip_pool_name" {
  type    = string
  default = "external2"
}
