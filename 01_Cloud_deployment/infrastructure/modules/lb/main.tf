# Explicitly set octavia to true
provider "openstack" {
  use_octavia = true
}

resource "openstack_networking_floatingip_v2" "floatip_1" {
  count = var.attach_floating

  description = "Fixed floating ip for hrvpp"
  pool        = var.floating_ip_pool_name
  fixed_ip    = openstack_lb_loadbalancer_v2.loadbalancer[0].vip_address
  port_id     = openstack_lb_loadbalancer_v2.loadbalancer[0].vip_port_id
}


resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name           = var.loadbalancer
  vip_network_id = var.network_id
  count          = var.create ? 1 : 0
}

module "dns_record" {
  source = "../dns/record"
  count          = var.create ? 1 : 0

  record_name      = "${var.loadbalancer}.${var.domain_name}"
  records          = var.attach_floating == 0 ? [
    openstack_lb_loadbalancer_v2.loadbalancer[0].vip_address
  ] : [
    openstack_networking_floatingip_v2.floatip_1[0].address
  ]
  external_zone_id = var.external_zone_id
}

module "dns_record_int" {
  source = "../dns/record"
  count          = var.create ? 1 : 0

  record_name      = "${var.loadbalancer}-int.${var.domain_name}"
  records          = [
    openstack_lb_loadbalancer_v2.loadbalancer[0].vip_address
  ]
  external_zone_id = var.external_zone_id
}

module "dns_record_sharding_ext" {
  source = "../dns/record"
  count = var.attach_floating == 0 ? 0 : 3

  record_name      = "${var.loadbalancer}-${count.index+1}.${var.domain_name}"
  records          = [
    openstack_networking_floatingip_v2.floatip_1[0].address
  ]
  external_zone_id = var.external_zone_id
}

locals {
  abc = ["a","b","c"]
  listeners = var.create ? {
    80 = { proto = "HTTP" }
    443 = { proto = "HTTPS" }
  } : {}
}

module "dns_record_sharding_ext_abc" {
  source = "../dns/record"
  count = var.attach_floating == 0 ? 0 : 3

  record_name      = "${var.loadbalancer}-${local.abc[count.index]}.${var.domain_name}"
  records          = [
    openstack_networking_floatingip_v2.floatip_1[0].address
  ]
  external_zone_id = var.external_zone_id
}

module "dns_record_sharding_int" {
  source = "../dns/record"
  count          = var.create ? 3 : 0

  record_name      = "${var.loadbalancer}-int-${count.index+1}.${var.domain_name}"
  records          = [
    openstack_lb_loadbalancer_v2.loadbalancer[0].vip_address
  ]
  external_zone_id = var.external_zone_id
}

module "dns_record_sharding_int_abc" {
  source = "../dns/record"
  count          = var.create ? 3 : 0

  record_name      = "${var.loadbalancer}-int-${local.abc[count.index]}.${var.domain_name}"
  records          = [
    openstack_lb_loadbalancer_v2.loadbalancer[0].vip_address
  ]
  external_zone_id = var.external_zone_id
}

resource "openstack_lb_listener_v2" "listener" {
  for_each = local.listeners

  name            = "listener_${each.value.proto}"
  protocol        = each.value.proto
  protocol_port   = each.key
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer[0].id
}

resource "openstack_lb_pool_v2" "pool" {
  for_each = var.pools

  name            = "pool_${each.key}"
  protocol        = each.value.proto
  lb_method       = "ROUND_ROBIN"
  listener_id     = openstack_lb_listener_v2.listener[each.value.port].id
  persistence {
    type = "HTTP_COOKIE"
  }
}

locals {
  pool_list = keys(var.pools)
}

/*
resource "openstack_lb_l7policy_v2" "l7policy" {
  for_each = var.pools

  name             = "l7policy_${each.key}"
  action           = "REDIRECT_TO_POOL"
  position         = index(local.pool_list, each.key) + 1
  listener_id      = openstack_lb_listener_v2.listener.id
  redirect_pool_id = openstack_lb_pool_v2.pool[each.key].id
}

resource "openstack_lb_l7rule_v2" "l7rule" {
  for_each = var.pools

  l7policy_id  = openstack_lb_l7policy_v2.l7policy[each.key].id
  type         = "PATH"
  compare_type = "REGEX"
  value        = each.value.regex_match
}
*/

locals {
  pool_members = flatten([
    for pool_key, pool in var.pools : [
      for node_key, ip in (length(pool.nodes) > 0 ? pool.nodes[0][0] : []) : {
          pool_id = openstack_lb_pool_v2.pool[pool_key].id
          ip      = ip
          port    = lookup(pool, "port", 8080)
      }
    ]
  ])
}

resource "openstack_lb_member_v2" "member" {
  count         = var.create ? length(local.pool_members) : 0

  depends_on    = [ openstack_lb_pool_v2.pool ]
  pool_id       = local.pool_members[count.index].pool_id
  address       = local.pool_members[count.index].ip
  protocol_port = local.pool_members[count.index].port
}
