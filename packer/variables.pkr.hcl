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
