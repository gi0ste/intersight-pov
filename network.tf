# the internal network to use for the observability VM
data "openstack_networking_network_v2" "internal_network" {
  name = var.network_name
}

# the subnet of the internal network
data "openstack_networking_subnet_v2" "internal_network_subnet" {
  name = "subnet"
  network_id = data.openstack_networking_network_v2.internal_network.id
}

# the public IP for the observability VM
resource "openstack_networking_floatingip_v2" "public_ip" {
  pool = "PublicNetwork"
}