data "openstack_networking_network_v2" "public_network" {
  network_id = var.external_network_id
}

resource "openstack_networking_network_v2" "devops_lab_network" {
  name = "devops-lab-network"
}

resource "openstack_networking_subnet_v2" "devops_lab_subnet" {
  name            = "devops-lab-subnet"
  network_id      = openstack_networking_network_v2.devops_lab_network.id
  cidr            = "10.0.3.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}

resource "openstack_networking_router_v2" "devops_lab_router" {
  name                = "devops-lab-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "router_link" {
  router_id = openstack_networking_router_v2.devops_lab_router.id
  subnet_id = openstack_networking_subnet_v2.devops_lab_subnet.id
}