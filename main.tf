
# Create the virtual machine
resource "vsphere_virtual_machine" "vm" {
  for_each = var.vms

  name                       = each.value.vm_name
  resource_pool_id           = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_cluster_id       = data.vsphere_datastore_cluster.items[each.key].id
  folder                     = var.vm_folder
  wait_for_guest_net_timeout = var.vm_guest_net_timeout
  num_cpus                   = each.value.vm_num_cpus
  memory                     = each.value.vm_memory


  # Apply tags directly to the VM resource
  tags = [
    for tag_category, tag_name in lookup(each.value, "vm_tags", {}) : 
      data.vsphere_tag.tags["${tag_category}-${tag_name}"].id
  ]

  disk {
    label            = each.value.vm_disk_label
    size             = each.value.vm_disk_size
    thin_provisioned = each.value.vm_disk_thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_content_library_item.items[each.key].id
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

}