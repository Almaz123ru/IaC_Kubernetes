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

variable "build_username" {
  type        = string
  description = "Пользователь, создаваемый autoinstall."
  default     = "ubuntu"
}

variable "build_password_hash" {
  type      = string
  sensitive = true
}

variable "build_password" {
  type        = string
  description = "Не используется при ssh_private_key_file; оставлено для совместимости secret-файла."
  default     = ""
  sensitive   = true
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
  type = string
}

variable "ssh_private_key_file" {
  type    = string
  default = "~/.ssh/id_rsa"
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
