locals {
  default_security_groups = ["base-${var.environment}-secgroup"]
}

data "openstack_images_image_v2" "vm_image" {
  name = var.image_name
}

resource "openstack_compute_instance_v2" "compute_node" {
  name            = "${var.compute_node_name}-${var.environment}-${count.index+1}"
  count           = var.extra_volume ? 0 : var.number_of_compute_nodes
  flavor_name     = var.flavor_name
  image_name      = var.image_name
  power_state     = contains(var.powered_off, "${var.compute_node_name}-${var.environment}-${count.index+1}") ? "shutoff" : "active"
  key_pair        = var.key_pair
  security_groups = concat(local.default_security_groups, var.security_groups)
  user_data       = var.puppet_env == "" ? templatefile("${path.module}/templates/user_data_nopuppet.tmpl", {
    fqdn       = "${var.compute_node_name}-${count.index+1}.${var.domain_name}"
  }) : templatefile("${path.module}/templates/user_data.tmpl", {
    fqdn       = "${var.compute_node_name}-${count.index+1}.${var.domain_name}"
    puppet_env = var.puppet_env
  })

  metadata = {
    depends_on = var.network_id
    ssh_user   = var.ssh_user
  }

  network {
    name = var.network_name
  }

  dynamic network {
    for_each = var.extra_networks
    content {
      name = network.value
    }
  }
}

resource "openstack_compute_instance_v2" "compute_node_extra_volume" {
  name            = "${var.compute_node_name}-${var.environment}-${count.index+1}"
  count           = var.extra_volume ? var.number_of_compute_nodes : 0
  flavor_name     = var.flavor_name
  image_name      = var.image_name
  power_state     = contains(var.powered_off, "${var.compute_node_name}-${var.environment}-${count.index+1}") ? "shutoff" : "active"
  key_pair        = var.key_pair
  security_groups = concat(local.default_security_groups, var.security_groups)
  user_data       = var.puppet_env == "" ? templatefile("${path.module}/templates/user_data_nopuppet.tmpl", {
    fqdn       = "${var.compute_node_name}-${count.index+1}.${var.domain_name}"
  }) : templatefile("${path.module}/templates/user_data.tmpl", {
    fqdn       = "${var.compute_node_name}-${count.index+1}.${var.domain_name}"
    puppet_env = var.puppet_env
  })

  metadata = {
    depends_on = var.network_id
    ssh_user   = var.ssh_user
  }

  network {
    name = var.network_name
  }

  dynamic network {
    for_each = var.extra_networks
    content {
      name = network.value
    }
  }
}

resource "openstack_blockstorage_volume_v2" "extra_volume" {
  count = var.extra_volume ? var.number_of_compute_nodes : 0
  name  = "${var.compute_node_name}-${var.environment}-${count.index+1}-volume"
  size  = var.volume_size
  volume_type  = var.volume_type
}

resource "openstack_compute_volume_attach_v2" "extra_volume_attach" {
  count       = var.extra_volume ? var.number_of_compute_nodes : 0
  instance_id = openstack_compute_instance_v2.compute_node_extra_volume[count.index].id
  volume_id   = openstack_blockstorage_volume_v2.extra_volume[count.index].id
}
