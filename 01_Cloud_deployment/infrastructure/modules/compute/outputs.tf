output "instance_id" {
  value = openstack_compute_instance_v2.compute_node[*].id
}

// Kept this for backwards compatibility
output "private_ip" {
  value = concat(openstack_compute_instance_v2.compute_node[*].access_ip_v4,
                 openstack_compute_instance_v2.compute_node_extra_volume[*].access_ip_v4)
}

output "private_ips" {
  value = concat(openstack_compute_instance_v2.compute_node[*].network[*].fixed_ip_v4,
                 openstack_compute_instance_v2.compute_node_extra_volume[*].network[*].fixed_ip_v4)
}
