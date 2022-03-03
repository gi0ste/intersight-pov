resource "openstack_networking_secgroup_v2" "obs_secgrp" {
  name        = "${var.obs_name}_secgrp"
  description = "Observability VM security group"
}

resource "openstack_networking_secgroup_rule_v2" "obs_secgrp_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "212.29.130.42/32"
  security_group_id = openstack_networking_secgroup_v2.obs_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "obs_secgrp_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "212.29.130.42/32"
  security_group_id = openstack_networking_secgroup_v2.obs_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "obs_secgrp_rule_kubeapi" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "212.29.130.42/32"
  security_group_id = openstack_networking_secgroup_v2.obs_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "obs_secgrp_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "212.29.130.42/32"
  security_group_id = openstack_networking_secgroup_v2.obs_secgrp.id
}

resource "openstack_networking_secgroup_rule_v2" "obs_secgrp_rule_all_internalnet" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = ""
  remote_ip_prefix  = data.openstack_networking_subnet_v2.internal_network_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.obs_secgrp.id
}
