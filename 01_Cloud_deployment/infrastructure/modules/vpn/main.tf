#
# STATIC ROUTES
#

resource "openstack_networking_router_route_v2" "router_vpn_routes" {
  for_each = var.vpn_router_routes
  router_id = var.router_id
  destination_cidr = each.value.destination_cidr
  next_hop         = var.vpngateway_ip
}

#
# VPNGATEWAY
#

locals {
  fqdn = "${var.compute_node_name}-1.${var.domain_name}"
}

data "openstack_images_image_v2" "vm_image" {
  name = var.image_name
}

module "dns_record" {
  source = "../dns/record"

  count            = var.create_dns ? 1 : 0
  record_name      = local.fqdn
  records          = [var.vpngateway_ip]
  external_zone_id = var.external_zone_id
}

#Had to import this as to not have it change on us
#resource "openstack_networking_floatingip_v2" "vpngateway_floatingip" {
#  pool        = "external"
#  address     = var.floating_ip
#  description = "VPN-OPNsense-17281-1"
#}

resource "openstack_compute_floatingip_associate_v2" "vpngateway" {
  #floating_ip = openstack_networking_floatingip_v2.vpngateway_floatingip.address
  floating_ip = var.floating_ip
  instance_id = openstack_compute_instance_v2.compute_node[0].id
}

resource "openstack_compute_instance_v2" "compute_node" {
  name            = "${var.compute_node_name}-${var.environment}-1"
  count           = 1
  flavor_name     = var.flavor_name
  image_name      = var.image_name
  key_pair        = "shared-${terraform.workspace}-keypair"
  power_state     = var.power_state
  user_data       = templatefile("${path.module}/templates/user_data.tmpl", {
                fqdn = local.fqdn
              })

  metadata = {
    ssh_user   = var.ssh_user
  }

  network {
    name = var.network_name
    fixed_ip_v4 = var.vpngateway_ip
  }
}
