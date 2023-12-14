variable "dns_nameservers"     { type = list(string) }
variable "external_network_id" { type = string }
variable "network_name"        { type = string }
variable "subnet_cidr"         { type = string }

variable "create_router" {
  type    = bool
  default = true
}
