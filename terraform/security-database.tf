resource "openstack_networking_secgroup_v2" "db_secgroup" {
  name = "db-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "db_postgres" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = openstack_networking_secgroup_v2.backend_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.db_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "db_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.db_secgroup.id
}