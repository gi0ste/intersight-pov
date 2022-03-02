# the observability VM
resource "openstack_compute_instance_v2" "obs_vm" {
  name = "observability-vm"
  flavor_name = "e3standard.x5"
  image_name = "template-focal-docker"

  key_pair = var.keypair_name

  security_groups = [ openstack_networking_secgroup_v2.obs_secgrp.name ]

  metadata = {
    Typology = "OBS"
    ManagedBy = "Terraform"
  }

  network {
    name = data.openstack_networking_network_v2.internal_network.name
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = var.ssh_key
      host = openstack_compute_instance_v2.obs_vm.access_ip_v4
    }

    inline = [ "while ! docker info; do echo \"Waiting for Docker...\"; sleep 1; done" ]

  }

}

# the observability VM public ip binding
resource "openstack_compute_floatingip_associate_v2" "obs_pubip_binding" {
  floating_ip = openstack_networking_floatingip_v2.public_ip.address
  instance_id = openstack_compute_instance_v2.obs_vm.id
}