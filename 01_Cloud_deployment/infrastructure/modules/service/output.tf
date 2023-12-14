output "ip_list" {
  value = module.compute_nodes[*].private_ip
}
