variable "vmware_datacenter" {
  type        = string
  description = "The vCenter datacenter to use"
}

variable "vmware_cluster" {
  type        = string
  description = "The vCenter cluster to use"
}

variable "vmware_datastore_cluster" {
  type        = string
  description = "The vCenter datastore cluster to use"
}

variable "vmware_network" {
  type        = string
  description = "The vCenter network to use"
}

variable "vmware_content_library" {
  type        = string
  description = "The vCenter content library to use"
}

variable "vmware_content_library_item" {
  type        = string
  description = "The vCenter content library item to use"
}

variable "vmware_content_library_item_type" {
  type        = string
  description = "The vCenter content library item type to use"
}

variable "vmware_tag_category" {
  type        = string
  description = "The vCenter tag category to use"
}

variable "vm_folder" {
  type        = string
  description = "The folder to place the virtual machine in"
  default     = "VMs"
}

variable "vm_guest_net_timeout" {
  type        = number
  description = "The timeout for guest network to be ready"
  default     = 0
}

variable "vm_domain" {
  type        = string
  description = "The domain to use for the virtual machine"
  default     = "local"
}

variable "vms" {
  type        = map(any)
  description = "List of VMs to deploy"
}