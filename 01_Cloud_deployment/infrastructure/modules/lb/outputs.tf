output "pools" {
  value = openstack_lb_pool_v2.pool
}

output "pool_members" {
  value = local.pool_members
}

output "balancer" {
  value = openstack_lb_loadbalancer_v2.loadbalancer
}
