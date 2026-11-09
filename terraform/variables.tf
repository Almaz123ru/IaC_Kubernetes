variable "pm_api_url" {
  description = "Proxmox API URL"
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID"
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  sensitive   = true
}

variable "node" {
  default = "pve"
}

variable "template_name" {
  default = "packer-ubuntu2404"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "vm_password" {
  description = "Пароль пользователя ubuntu (cloud-init)."
  sensitive   = true
  default     = ""
}

# --- K3S cluster ---
variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 2
}

# --- NETWORK MODE ---
# dhcp или static
variable "network_mode" {
  default = "dhcp"
}

# если static
variable "gateway" {
  default = "192.168.1.1"
}

variable "cidr" {
  default = "24"
}

variable "master_ips" {
  type    = list(string)
  default = ["192.168.1.100"]
}

variable "worker_ips" {
  type    = list(string)
  default = ["192.168.1.101", "192.168.1.102"]
}