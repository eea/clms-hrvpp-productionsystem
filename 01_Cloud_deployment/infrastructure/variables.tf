# Spark worker specific parameters

variable "provision_spark_workers" {
  type    = bool
  default = true
}
variable "spark_worker_image_name" {
  type    = string
  default = "none"
}
variable "spark_worker_network_external_id" {
  type    = string
  default = "959e9209-cf65-4afe-b17e-c5bfecdb0075"
}

variable "dns_zone_id" {
  type    = string
  default = "ab459a7b-879d-4991-9c64-9cc121e44d86"
}

variable "image_name" {
  type    = string
  default = "puppet_base_image-alma82022-07-01_08-41-36"
}

variable "graphite_name" {
  type    = string
  default = "puppet_base_image-centos72022-07-12_10-07-22"
}

variable "wmts_image" {
  type    = string
  default = "puppet_base_image-alma82022-07-01_08-41-36"
}

# BASE

variable "manage_secgroup" {
  type    = bool
  default = false
}
variable "manage_dns" {
  type    = bool
  default = false
}

# NETWORK

variable "domain_name" {
  type    = string
  default = "hrvpp2.vgt.vito.be"
}

variable "network_id" {
  type    = string
  default = "c99bed21-4551-4619-8f40-cc83ba4e8807"
}

variable "network_name" {
  type    = string
  default = "vito_tap_VPN"
}

variable "subnet_cidr" {
  type    = string
  default = "192.168.151.0/24"
}

variable "network_external_id" {
  type    = string
  default = "959e9209-cf65-4afe-b17e-c5bfecdb0075"
}

variable "vito_tap_vpn_network_create" {
  type    = bool
  default = false
}

variable "vito_tap_vpn_network_name" {
  type    = string
  default = "vito_tap_VPN"
}

variable "vito_tap_vpngateway_routes" {
   type = map
   default = {}
}

variable "spark_vpngateway_routes" {
   type = map
   default = {}
}

# CREATE NODE MGMT

variable "provision_nifi" {
  type    = bool
  default = false
}

variable "provision_ingest" {
  type    = bool
  default = false
}

variable "provision_kibana" {
  type    = bool
  default = false
}

variable "provision_elasticsearch" {
  type    = bool
  default = false
}

variable "provision_graphite" {
  type    = bool
  default = false
}

variable "provision_spark_history" {
  type    = bool
  default = false
}

variable "provision_oscars" {
  type    = bool
  default = false
}

variable "provision_oscars_download" {
  type    = bool
  default = false
}

variable "provision_wmts" {
  type    = bool
  default = false
}

variable "provision_web" {
  type    = bool
  default = false
}

variable "provision_spark_master_vi" {
  type    = bool
  default = false
}

variable "spark_master_vi_extra_network" {
  type    = string
  default = "eodata_17281_1"
}

variable "provision_spark_master_ts" {
  type    = bool
  default = false
}

variable "spark_master_ts_extra_network" {
  type    = string
  default = "eodata_17281_1"
}

variable "provision_spark_master_seed" {
  type    = bool
  default = false
}

variable "spark_master_seed_extra_network" {
  type    = string
  default = "eodata_17281_1"
}

variable "dns_nameservers" {
  type    = list(string)
  default = ["193.191.168.130", "193.191.168.133"]
}

variable "puppet_env" {
  type    = string
  default = "hr_vpp_prd"
}

# Elasticsearch variables

variable "es_compute_node_name" {
  type    = string
  default = "es"
}

variable "es_flavor_name" {
  type    = string
  default = "eo1.large"
}

variable "es_number_of_nodes" {
  type    = number
  default = 3
}

variable "es_volume_size" {
  type    = number
  default = 250
}

variable "es_volume_type" {
  type    = string
  default = "ssd"
}

# Graphite variables

variable "graphite_flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "graphite_volume_size" {
  type    = number
  default = 200
}

variable "graphite_volume_type" {
  type    = string
  default = "hdd"
}

variable "mgmt_puppet_env" {
  type    = string
  default = "mgmt_prod"
}

# Kibana variables

variable "kibana_flavor_name" {
  type    = string
  default = "eo1.medium"
}

# Nifi variables

variable "nifi_flavor_name" {
  type    = string
  default = "eo1.large"
}

variable "nifi_volume_size" {
  type    = number
  default = 200
}

variable "nifi_volume_type" {
  type    = string
  default = "hdd"
}

# Ingest variables

variable "ingest_flavor_name" {
  type    = string
  default = "eo1.large"
}

# Spark master variables

variable "spark_master_flavor_name" {
  type    = string
  default = "eo2.large"
}

# Spark history variables

variable "spark-history_flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "spark-history_extra_network" {
  type    = string
  default = "eodata_17281_1"
}

# Spark worker variables

variable "spark_worker_nodes" {
  type    = number
  default = 1
}

variable "spark_worker_nodes_powered_off" {
  type    = list(string)
  default = []
}

variable "spark_worker_flavor_name" {
  type    = string
  default = "eo2.xlarge"
}

variable "spark_worker_extra_volume" {
  type    = bool
  default = false
}

variable "volume_size" {
  type    = number
  default = 512
}

variable "volume_type" {
  type    = string
  default = "ssd"
}

# SPARK WORKER NETWORK

variable "spark_worker_network_create" {
  type    = bool
  default = false
}

variable "spark_worker_network_name" {
  type = string
  default = "spark_worker"
}

variable "spark_worker_subnet_cidr" {
  type = string
  default = "10.151.0.0/16"
}

variable "spark_worker_network_dns" {
  type    = list(string)
  default = ["193.191.168.130", "193.191.168.133"]
}

variable "spark_worker_network" {
  type    = string
  default = "big_eodata_17281_1"
}

variable "spark_worker_secgroup_create" {
  type    = bool
  default = false
}


# OSCARS variables

variable "oscars_flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "oscars_nodes" {
  type    = number
  default = 2
}

variable "oscars_download_flavor_name" {
  type    = string
  default = "eo1.large"
}

variable "oscars_download_nodes" {
  type    = number
  default = 2
}

# WMTS variables

variable "wmts_flavor_name" {
  type    = string
  default = "eo1.large"
}

variable "wmts_nodes" {
  type    = number
  default = 2
}

# LOADBALANCER

variable "lb_create" {
  type    = bool
  default = false
}

variable "lb_name" {
  type    = string
  default = "phenology"
}

variable "lb_floating_ip" {
  type    = number
  default = 0
}

variable "lb_floating_ip_pool_name" {
  type    = string
  default = "external"
}

variable "web_flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "web_nodes" {
  type    = number
  default = 2
}

# VPNGATEWAY variables

variable "provision_vito_tap_vpngateway" {
  type    = bool
  default = false
}

variable "vpngateway_flavor_name" {
  type    = string
  default = "eo1.medium"
}

variable "vito_tap_vpngateway_image" {
   type    = string
   default = "vpngateway-vpn_tap_network-alma82022-09-19_08-23-27"
}

variable "provision_spark_vpngateway" {
  type    = bool
  default = false
}

variable "spark_vpngateway_image" {
   type    = string
   default = "vpngateway-spark_network-alma82022-09-20_06-43-52"
}
