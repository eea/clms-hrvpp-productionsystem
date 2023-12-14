resource "openstack_networking_network_v2" "private_network" {
  name           = var.network_name
  admin_state_up = true
}

resource "openstack_networking_router_v2" "router" {
  count               = var.create_router ? 1 : 0
  name                = "${var.network_name}-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_subnet_v2" "private_network_subnet" {
  name            = "${var.network_name}-subnet"
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_interface_v2" "private_network_router_interface" {
  count     = var.create_router ? 1 : 0
  router_id = openstack_networking_router_v2.router[0].id
  subnet_id = openstack_networking_subnet_v2.private_network_subnet.id
}
