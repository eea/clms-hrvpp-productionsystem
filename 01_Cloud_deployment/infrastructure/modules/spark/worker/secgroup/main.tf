module "spark-worker-secgroup" {
  source = "../../../secgroup"

  prefix         = var.secgroup_prefix
  rules          = {
                     "spark_webui"     = { "port" = 8081, "remote_ip_prefix" = [var.spark_worker_subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                     "spark_webui_ssl" = { "port" = 8481, "remote_ip_prefix" = [var.spark_worker_subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                   }
  rules_range    = {
                     "intern_traffic" = { "port_range_min" = 0, "port_range_max" = 0, "remote_ip_prefix" = toset([var.subnet_cidr, var.spark_worker_subnet_cidr]) }
                   }
}
