variable "prefix" { type = string }

variable "description" {
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
