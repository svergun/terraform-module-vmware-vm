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
