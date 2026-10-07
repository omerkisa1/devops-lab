resource "openstack_networking_secgroup_v2" "worker_secgroup" {
  name = "worker-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "worker_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.worker_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "worker_kubelet_from_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = openstack_networking_secgroup_v2.master_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.worker_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "worker_vxlan_from_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8472
  port_range_max    = 8472
  remote_group_id   = openstack_networking_secgroup_v2.master_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.worker_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "worker_canal_health_from_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9099
  port_range_max    = 9099
  remote_group_id   = openstack_networking_secgroup_v2.master_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.worker_secgroup.id
}