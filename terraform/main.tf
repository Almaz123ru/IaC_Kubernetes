terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url

  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret

  pm_tls_insecure = true
}

# ---------- MASTER ----------

resource "proxmox_vm_qemu" "master" {
  count = var.master_count

  name        = "k3s-master-${count.index}"
  target_node = var.node
  clone       = var.template_name
  full_clone  = true


  cpu { cores = 2 }
  memory      = 2048

  scsihw      = "virtio-scsi-single"

  disks {
    scsi{
      scsi0{
        disk{
          size    = "20G"
          storage = "local-lvm"
        }
      }
    }
  }


  agent       = 1

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }


  ipconfig0 = var.network_mode == "dhcp" ? "ip=dhcp" : "ip=${var.master_ips[count.index]}/${var.cidr},gw=${var.gateway}"

  sshkeys = file(var.ssh_public_key)
}

# ---------- WORKERS ----------

resource "proxmox_vm_qemu" "workers" {
  count = var.worker_count

  name        = "k3s-worker-${count.index}"
  target_node = var.node
  clone       = var.template_name
  full_clone  = true
  scsihw      = "virtio-scsi-single"


  cpu { cores = 2 }
  memory      = 2048

  agent       = 1

  disks {
    scsi{
      scsi0{
        disk{
          size    = "20G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = var.network_mode == "dhcp" ? "ip=dhcp" : "ip=${var.worker_ips[count.index]}/${var.cidr},gw=${var.gateway}"

  sshkeys = file(var.ssh_public_key)
}

# ---------- INVENTORY GENERATION ----------

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    masters = proxmox_vm_qemu.master[*].default_ipv4_address
    workers = proxmox_vm_qemu.workers[*].default_ipv4_address
  })

  filename = "../ansible/inventory.ini"
}
