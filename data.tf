# Get the VMware vSphere datacenter data
data "vsphere_datacenter" "datacenter" {
  name = var.vmware_datacenter
}

# Get the VMware vSphere cluster data
data "vsphere_compute_cluster" "cluster" {
  name          = var.vmware_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Get the VMware vSphere datastore cluster data
data "vsphere_datastore_cluster" "items" {
  for_each = var.vms

  name          = each.value.vmware_datastore_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Get the VMware vSphere network data
data "vsphere_network" "network" {
  name          = var.vmware_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Data source for vCenter Content Library
data "vsphere_content_library" "library" {
  name = var.vmware_content_library
}

# Data source for vCenter Content Library Item
data "vsphere_content_library_item" "items" {
  for_each = var.vms

  name       = each.value.vmware_content_library_item
  type       = var.vmware_content_library_item_type
  library_id = data.vsphere_content_library.library.id
}

# Get tag categories that we need
data "vsphere_tag_category" "categories" {
  for_each = toset(distinct(flatten([
    for vm in var.vms : keys(lookup(vm, "vm_tags", {}))
  ])))
  name = each.key
}

# Get tags that we need to assign
data "vsphere_tag" "tags" {
  for_each = {
    for tag in flatten([
      for vm_key, vm in var.vms : [
        for tag_category, tag_name in lookup(vm, "vm_tags", {}) : {
          key = "${tag_category}-${tag_name}"
          category_id = data.vsphere_tag_category.categories[tag_category].id
          name = tag_name
        }
      ]
    ]) : tag.key => tag
  }

  name = each.value.name
  category_id = each.value.category_id
}