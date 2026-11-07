variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
  type = string
}


# ---------------------------------------------------------------------------
# Сеть установщика
# ---------------------------------------------------------------------------

variable "build_network_mode" {
  type        = string
  description = "dhcp или static."
  default     = "dhcp"

  validation {
    condition     = contains(["dhcp", "static"], var.build_network_mode)
    error_message = "Режим build_network_mode должен быть dhcp или static."
  }
}

variable "build_ip_cidr" {
  type        = string
  description = "Статический IPv4 сборки в CIDR (для static)."
  default     = "10.0.0.50/24"
}

variable "build_gateway" {
  type        = string
  description = "Шлюз для static."
  default     = "10.0.0.1"
}
