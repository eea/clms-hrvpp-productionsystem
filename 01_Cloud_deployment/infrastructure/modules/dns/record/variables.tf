variable "record_type" {
  type        = string
  description = "The type of record to add"
  default     = "A"
}

variable "record_name" {
  type        = string
  description = "The record name to add"
}

variable "records" {
  type        = list(string)
  description = "A list of ips to point to the record"
}

variable "external_zone_id" {
  type        = string
  description = "The ID of the external zone, cuz inheriting output params isn't a thing"
}
