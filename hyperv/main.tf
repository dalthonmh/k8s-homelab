variable "hostname" {
  description = "Node name default"
  type        = string
  default     = "worker1" 
  validation {
    condition     = length(var.hostname) > 0
    error_message = "Instance type cannot be empty."
  }
  sensitive = false
}

terraform {
  required_providers {
    hyperv = {
      source = "tonybaloney/hyperv"
    }
  }
}

provider "hyperv" {}

# Se usa 'worker' por defecto, no afecta al nombre real var.hostname
resource "hyperv_virtual_machine" "worker" { 
  name               = var.hostname 
  
  generation         = 2
  processor_count    = 2
  memory_startup_bytes = 2048
  switch_name        = "Default Switch"
  dynamic_memory     = true

  hard_disk {
    path = "D:\\VMs\\${var.hostname}.vhdx" 
    size = 20000
  }

  dvd_drive {
    path = "D:\\iso\\debian-13-amd64-netinst.iso"
  }

  boot_order             = ["CD", "HDD", "Network"]
  automatic_start_action = "StartIfRunning"
}