# -----------------------------------------------------------------------------
# LXC CONTAINER MODULE VARIABLES
# -----------------------------------------------------------------------------

variable "vm_id" {
  type        = number
  description = "The VM ID for the container"
}

variable "hostname" {
  type        = string
  description = "The hostname for the container"
}

variable "description" {
  type        = string
  description = "Description of the container"
}

variable "node_name" {
  type        = string
  description = "The Proxmox node name"
}

variable "clone_vm_id" {
  type        = number
  description = "The VM ID of the template to clone from"
  default     = 9902
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
}

variable "disk_datastore_id" {
  type        = string
  description = "Datastore ID for the disk"
  default     = "Cesspool-LXC"
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

variable "network_bridge" {
  type        = string
  description = "Network bridge name"
  default     = "vmbr0"
}

variable "mac_address" {
  type        = string
  description = "MAC address for the network interface"
}

variable "started" {
  type        = bool
  description = "Whether the container should be started"
  default     = true
}

variable "mount_points" {
  type = list(object({
    volume    = string
    path      = string
    replicate = bool
  }))
  description = "List of mount points for the container"
  default     = []
}

variable "device_passthroughs" {
  type = list(object({
    path = string
    gid  = number
  }))
  description = "List of device passthroughs for the container"
  default     = []
}

variable "unprivileged" {
  type        = bool
  description = "Whether the container should be unprivileged"
  default     = true
}

