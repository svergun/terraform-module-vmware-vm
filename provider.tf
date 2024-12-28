# Configure the VMware vSphere provider
provider "vsphere" {
  user                 = var.vmware_vcenter_user
  password             = var.vmware_vcenter_password
  vsphere_server       = var.vmware_vcenter_server
  allow_unverified_ssl = var.vmware_unverified_ssl
}
