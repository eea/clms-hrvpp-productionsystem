locals {
  default_rule_attributes = {
    "direction"        = "ingress"
    "ethertype"        = "IPv4"
    "protocol"         = "tcp"
    "remote_ip_prefix" = ["0.0.0.0/0"]
  }

  // Flatten the rules map to have one map per remote_ip_prefix
  rules_per_subnet = flatten([
    for rule_key, rule in var.rules : [
      for remote_ip_prefix_key, remote_ip_prefix in rule.remote_ip_prefix : {
        direction        = lookup(rule, "direction", local.default_rule_attributes.direction)
        ethertype        = lookup(rule, "ethertype", local.default_rule_attributes.ethertype)
        protocol         = lookup(rule, "protocol", local.default_rule_attributes.protocol)
        port             = rule.port
        remote_ip_prefix = remote_ip_prefix
      }
    ]
  ])
  rules_range_per_subnet = flatten([
    for rule_key, rule in var.rules_range : [
      for remote_ip_prefix_key, remote_ip_prefix in rule.remote_ip_prefix : {
        direction        = lookup(rule, "direction", local.default_rule_attributes.direction)
        ethertype        = lookup(rule, "ethertype", local.default_rule_attributes.ethertype)
        port_range_max   = rule.port_range_max
        port_range_min   = rule.port_range_min
        protocol         = lookup(rule, "protocol", local.default_rule_attributes.protocol)
        remote_ip_prefix = remote_ip_prefix
      }
    ]
  ])
  rules_any_port_subnet = flatten([
    for rule_key, rule in var.rules_any_port : [
      for remote_ip_prefix_key, remote_ip_prefix in rule.remote_ip_prefix : {
        direction        = lookup(rule, "direction", local.default_rule_attributes.direction)
        ethertype        = lookup(rule, "ethertype", local.default_rule_attributes.ethertype)
        protocol         = lookup(rule, "protocol", local.default_rule_attributes.protocol)
        remote_ip_prefix = remote_ip_prefix
      }
    ]
  ])
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.prefix}-secgroup"
  description = var.description
}

resource "openstack_networking_secgroup_rule_v2" "secrule" {
  for_each          = {
    for subnet in local.rules_per_subnet: "port-${subnet.port}-subnet-${subnet.remote_ip_prefix}" => subnet
  }

  direction         = each.value.direction
  ethertype         = each.value.ethertype
  port_range_min    = each.value.port
  port_range_max    = each.value.port
  protocol          = each.value.protocol
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secrule_range" {
  for_each          = {
    for subnet in local.rules_range_per_subnet: "range-${subnet.port_range_min}-${subnet.port_range_max}-${subnet.protocol}-subnet-${subnet.remote_ip_prefix}" => subnet
  }

  direction         = each.value.direction
  ethertype         = each.value.ethertype
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  protocol          = each.value.protocol
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "secrule_any_port" {
  for_each          = {
    for subnet in local.rules_any_port_subnet: "${subnet.protocol}-${subnet.direction}-subnet-${subnet.remote_ip_prefix}" => subnet
  }

  direction         = each.value.direction
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}
