resource "openstack_networking_secgroup_v2" "nginx_secgroup" {
  name                 = "nginx-secgroup"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "backend_secgroup" {
  name                 = "backend-secgroup"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "nginx_http_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_https_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}
resource "openstack_networking_secgroup_rule_v2" "nginx_http_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_https_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_to_backend" {
  security_group_id = openstack_networking_secgroup_v2.nginx.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8000
  port_range_max    = 8000
  remote_group_id   = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_dns_udp" {
  security_group_id = openstack_networking_secgroup_v2.nginx.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "1.1.1.1/32"
}
