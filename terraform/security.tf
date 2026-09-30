# nginx secgroup
resource "openstack_networking_secgroup_v2" "nginx_secgroup" {
  name                 = "nginx-secgroup"
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
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_to_backend" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8000
  port_range_max    = 8000
  remote_group_id   = openstack_networking_secgroup_v2.backend_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id

}

resource "openstack_networking_secgroup_rule_v2" "nginx_dns_udp" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "1.1.1.1/32"
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
}

# backend secgroup
resource "openstack_networking_secgroup_v2" "backend_secgroup" {
  name                 = "backend-secgroup"
  delete_default_rules = true
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
  remote_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "backend_ssh_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}


resource "openstack_networking_secgroup_rule_v2" "backend_http" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "backend_https" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "backend_dns" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_dhcp_egress" {
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 67
  port_range_max    = 67
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "nginx_dhcp_ingress" {
  security_group_id = openstack_networking_secgroup_v2.nginx_secgroup.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 68
  port_range_max    = 68
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "backend_dhcp_egress" {
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 67
  port_range_max    = 67
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "backend_dhcp_ingress" {
  security_group_id = openstack_networking_secgroup_v2.backend_secgroup.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 68
  port_range_max    = 68
  remote_ip_prefix  = "0.0.0.0/0"
}