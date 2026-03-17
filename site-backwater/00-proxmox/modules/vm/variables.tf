# -----------------------------------------------------------------------------
# VM MODULE VARIABLES
# -----------------------------------------------------------------------------

variable "vm_id" {
  type        = number
  description = "The VM ID for the virtual machine"
}

variable "name" {
  type        = string
  description = "The name of the virtual machine"
}

variable "description" {
  type        = string
  description = "Description of the virtual machine"
}

variable "node_name" {
  type        = string
  description = "The Proxmox node name"
}

variable "clone_vm_id" {
  type        = number
  description = "The VM ID of the template to clone from"
  default     = 9903
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores"
}

variable "cpu_units" {
  type        = number
  description = "CPU units (weight)"
}

variable "memory_dedicated" {
  type        = number
  description = "Dedicated memory in MB"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
}

variable "disk_datastore_id" {
  type        = string
  description = "Datastore ID for the disk"
  default     = "Cesspool-VM"
}

variable "disk_interface" {
  type        = string
  description = "Disk interface (e.g., scsi0)"
  default     = "scsi0"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge name"
  default     = "vmbr0"
}

variable "mac_address" {
  type        = string
  description = "MAC address for the network device"
}

variable "agent_enabled" {
  type        = bool
  description = "Whether the QEMU agent is enabled"
  default     = true
}

