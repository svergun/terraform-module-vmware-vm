# Output VM names from the virtual_machine module
output "vm_name" {
  value = { for vm_key, vm_value in vsphere_virtual_machine.vm : vm_key => vm_value.name }
}

# Output VM default_ip_addresses from the virtual_machine module
output "default_ip_address" {
  value = { for vm_key, vm_value in vsphere_virtual_machine.vm : vm_key => vm_value.default_ip_address }
}

# Output guest_ip_addresses from the virtual_machine module
output "guest_ip_addresses" {
  value = { for vm_key, vm_value in vsphere_virtual_machine.vm : vm_key => vm_value.guest_ip_addresses }
}

output "datastore_cluster_names" {
  value = [for vm in var.vms : vm.vmware_datastore_cluster]
}