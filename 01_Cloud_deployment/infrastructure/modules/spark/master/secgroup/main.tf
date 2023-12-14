module "spark-master-secgroup" {
  source = "../../../secgroup"

  prefix         = var.secgroup_prefix
  rules          = {
                     "spark_webui"     = { "port" = 8080, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                     "spark_webui_ssl" = { "port" = 8480, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                     "livy_webui"      = { "port" = 8082, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "192.168.205.0/24", "172.24.236.0/23"] }
                   }
  rules_range    = {
                     "intern_traffic" = { "port_range_min" = 0, "port_range_max" = 0, "remote_ip_prefix" = toset([var.subnet_cidr, var.spark_worker_subnet_cidr]) }
                     "spark_driverui" = { "port_range_min" = 4050, "port_range_max" = 4100, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                     "spark_driverui_ssl" = { "port_range_min" = 4450, "port_range_max" = 4500, "remote_ip_prefix" = [var.subnet_cidr, "192.168.120.0/24", "172.24.28.0/24", "172.24.24.0/24", "172.24.200.0/23", "172.24.216.0/23", "172.16.10.0/24", "172.24.236.0/23"] }
                   }
}
