resource "openstack_networking_floatingip_v2" "nginx_vm_floatingip" {
  pool = data.openstack_networking_network_v2.public_network.name
}

resource "openstack_compute_floatingip_associate_v2" "nginx_floatingip_attach" {
  floating_ip = openstack_networking_floatingip_v2.nginx_vm_floatingip.address
  instance_id = openstack_compute_instance_v2.nginx_vm.id
}

resource "openstack_compute_instance_v2" "nginx_vm" {
  name            = "nginx-vm"
  flavor_id       = var.medium_flavor_id
  key_pair        = openstack_compute_keypair_v2.devops_lab_key.name
  security_groups = [openstack_networking_secgroup_v2.nginx_secgroup.name] # I will add the secgroup

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = openstack_networking_network_v2.devops_lab_network.id
  }
}

resource "openstack_compute_instance_v2" "backend_vm" {
  name            = "backend-vm"
  flavor_id       = var.medium_flavor_id
  key_pair        = openstack_compute_keypair_v2.devops_lab_key
  security_groups = [openstack_networking_secgroup_v2.backend_secgroup.name] # I will add the secgroup

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = openstack_networking_network_v2.devops_lab_network.id
  }

}