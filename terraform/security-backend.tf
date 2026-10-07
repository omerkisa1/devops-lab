resource "openstack_networking_secgroup_v2" "backend_secgroup" {
  name = "backend-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "backend_to_nginx" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8000
  port_range_max    = 8000
  remote_group_id   = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "backend_ssh_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}