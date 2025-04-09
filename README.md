# Terraform Module - VMware Virtual Machine

This Terraform module creates VMware Virtual Machines with configurable properties and tag support.

## Overview

This module provides a flexible way to deploy virtual machines in a VMware environment with customizable settings and tag support. It allows you to provision multiple VMs with different configurations in a single module declaration.

## Requirements

* Terraform >= 1.0
* VMware vSphere Provider ~> 2.10.0
* VMware vCenter Server
* Proper permissions to create and configure virtual machines
* Existing content library with VM templates

## Module Features

* Deploy multiple VMs with different configurations
* Support for VMware tags
* Customizable VM properties (CPUs, memory, disk, etc.)
* Support for VM templates from Content Library
* Network configuration

## Input Variables

### Required Variables

| Variable Name | Description | Type |
|---------------|-------------|------|
| `vmware_datacenter` | The vCenter datacenter to use | string |
| `vmware_cluster` | The vCenter cluster to use | string |
| `vmware_network` | The vCenter network to use | string |
| `vmware_content_library` | The vCenter content library to use | string |
| `vmware_content_library_item_type` | The vCenter content library item type to use | string |
| `vms` | Map of VMs to deploy with their configurations | map(any) |

### Optional Variables

| Variable Name | Description | Type | Default |
|---------------|-------------|------|---------|
| `vmware_datastore_cluster` | The vCenter datastore cluster to use | string | "" |
| `vmware_content_library_item` | The vCenter content library item to use | string | "" |
| `vm_folder` | The folder to place the virtual machine in | string | "VMs" |
| `vm_guest_net_timeout` | The timeout for guest network to be ready | number | 0 |
| `vm_domain` | The domain to use for the virtual machine | string | "local" |

### VM Configuration Options

Each VM in the `vms` map can have the following properties:

```hcl
{
  vm_name = "example-vm"
  vm_num_cpus = 2
  vm_memory = 4096
  vm_disk_label = "disk0"
  vm_disk_size = 40
  vm_disk_thin_provisioned = true
  vmware_content_library_item = "ubuntu-2204-template"
  vmware_datastore_cluster = "datastore-cluster-01"
  vm_tags = {
    application = "app-name"
    deployed_by = "terraform"
    os_family = "linux"
  }
}
```

## Outputs

| Output Name | Description |
|-------------|-------------|
| `vm_name` | Map of VM keys to VM names |
| `default_ip_address` | Map of VM keys to default IP addresses |
| `guest_ip_addresses` | Map of VM keys to all guest IP addresses |
| `datastore_cluster_names` | List of datastore cluster names |
| `vm_tags` | Map of VM keys to their assigned tags |

## Tags Support

This module supports VMware tags to organize your VMs. Tags must be defined in vCenter before they can be used with this module. The format for defining tags is:

```hcl
vm_tags = {
  category_name = "tag_name"
}
```

For example:

```hcl
vm_tags = {
  application = "app-server"
  deployed_by = "terraform"
  os_family = "linux"
}
```

## Example Usage

```hcl
module "vm" {
  source = "git::https://github.com/svergun/terraform-module-vmware-vm.git"

  vmware_datacenter        = "DC-01"
  vmware_cluster           = "Cluster-01"
  vmware_network           = "VM Network"
  vmware_content_library   = "Templates"
  vmware_content_library_item_type = "ovf"

  vm_folder            = "Production"
  vm_guest_net_timeout = 5

  vms = {
    app_server = {
      vm_name                     = "app-server-01"
      vm_num_cpus                 = 4
      vm_memory                   = 8192
      vm_disk_label               = "disk0"
      vm_disk_size                = 80
      vm_disk_thin_provisioned    = true
      vmware_content_library_item = "ubuntu-2204-template"
      vmware_datastore_cluster    = "SSD-Cluster"
      vm_tags                     = {
        application = "app-server"
        deployed_by = "terraform"
        os_family = "linux"
              }
    },
    db_server = {
      vm_name                     = "db-server-01"
      vm_num_cpus                 = 8
      vm_memory                   = 16384
      vm_disk_label               = "disk0"
      vm_disk_size                = 120
      vm_disk_thin_provisioned    = true
      vmware_content_library_item = "ubuntu-2204-template"
      vmware_datastore_cluster    = "SSD-Cluster"
      vm_tags                     = {
        application = "database"
        deployed_by = "terraform"
        os_family = "linux"
              }
    }
  }
}

output "vm_ips" {
  value = module.vm.default_ip_address
}
```
