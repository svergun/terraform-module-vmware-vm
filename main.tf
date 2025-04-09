data "vsphere_tag" "tags" {
  for_each = toset(flatten([
    for vm in var.vms : [
      for tag_key, tag_value in vm.vm_tags : format("%s_%s", tag_key, tag_value)
    ]
  ]))
  name        = split("_", each.key)[1]
  category_id = data.vsphere_tag_category.categories[split("_", each.key)[0]].id
}

data "vsphere_tag_category" "categories" {
  for_each = toset([
    for vm in var.vms : keys(vm.vm_tags)
  ])
  name = each.key
}

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

#Apply tags to the VM
resource "vsphere_tag_association" "vm_tags" {
  for_each = flatten([
    for vm_key, vm in var.vms : [
      for tag_key, tag_value in vm.vm_tags : {
        vm_id     = vsphere_virtual_machine.vm[vm_key].id
        tag_key   = tag_key
        tag_value = tag_value
        vm_key    = vm_key
      }
    ]
  ])
  # Use the vsphere_tag data source to get the tag ID
  tag_ids = [
    data.vsphere_tag.tags[format("%s_%s", each.value.tag_key, each.value.tag_value)].id
  ]
  object_id = each.value.vm_id
}