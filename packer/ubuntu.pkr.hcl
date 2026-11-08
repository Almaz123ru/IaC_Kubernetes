packer {
  required_version = ">= 1.10.0"
  required_plugins {
    name = {
      version = "1.2.4"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {

    # Proxmox Connection Settings
    proxmox_url = var.proxmox_api_url
    username    = var.proxmox_api_token_id
    token       = var.proxmox_api_token_secret
    node        = "pve"

    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true

    # VM General Settings
    vm_id                = 9000
    vm_name              = "packer-ubuntu-2604"
    template_name        = "packer-ubuntu2604-template"
    template_description = "ubuntu-26-cloudinit-template"
    tags                 = "ubuntu;2604;template"
    

    bios            = local.bios
    machine         = local.machine
    os              = local.os_type
    cpu_type        = local.cpu_type
    cores           = 2
    sockets         = local.cpu_sockets
    memory          = 2048
    scsi_controller = local.scsi_controller   # "virtio-scsi-pci"
    qemu_agent      = local.qemu_agent
    boot            = local.boot_order  # "order=scsi0;ide2"

    disks {
        disk_size    = "20G"
        storage_pool = "local-lvm"
        type         = local.disk_type
        format       = local.disk_format
        io_thread    = local.disk_io_thread
        discard      = local.disk_discard
        ssd          = local.disk_ssd
    }

    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = false
        vlan_tag = ""
    }


    # (Option 1) Local ISO File
    boot_iso{
        type              = local.boot_iso_type
        index             = local.boot_iso_index
        iso_file         = "local:iso/ubuntu-26.04.1-live-server-amd64.iso"
        iso_storage_pool = "local"
        unmount           = local.boot_iso_unmount
        keep_cdrom_device = local.boot_iso_keep_cdrom
    }
        # - or -
    # (Option 2) Download ISO
    # boot_iso {
    #    type              = local.boot_iso_type
    #    index             = local.boot_iso_index
    #    iso_url           = "https://releases.ubuntu.com/26.04/ubuntu-26.04.1-live-server-amd64.iso"
    #    iso_checksum      = "cc8a95cde20f6ced61a322420de00f10cc3c90ced545daa46cb9c1a117f1d927"
    #    iso_storage_pool  = "local"
    #    iso_download_pve  = true
    #    unmount           = local.boot_iso_unmount
    #    keep_cdrom_device = local.boot_iso_keep_cdrom
    # }

    http_bind_address = "0.0.0.0"
    http_content = {
        "/user-data" = templatefile("${path.root}/http/user-data.pkrtpl", {
        build_hostname      = "ubuntu-2604-template"
        build_username      = "ubuntu"
        build_password_hash = var.build_password_hash
        timezone            = "Europe/Moscow"
        build_network_mode  = "dhcp"
        build_ip_cidr       = "10.0.0.50/24"
        build_gateway       = "10.0.0.1"
        ssh_authorized_keys = [local.ssh_public_key]
        })
        "/meta-data" = templatefile("${path.root}/http/meta-data.pkrtpl", {
        build_hostname = "ubuntu-2604-template"
        })
    }

    boot_wait = "10s"
    boot_key_interval = local.boot_key_interval
    # PACKER Boot Commands
    boot_command = [
      "<wait><esc><wait>",
      "e<wait>",
      "<down><wait><down><wait><down><wait><end>",
      "<bs><bs><wait><bs><bs><bs><wait>",
      " autoinstall ds=nocloud\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
      "<f10><wait>"
    ]

    ssh_username           = "ubuntu"
    ssh_timeout            = "20m"
    ssh_handshake_attempts = local.ssh_handshake_attempts

    # (Option 1) Password
    # ssh_password           = var.build_password
    # - or -
    # (Option 2) Private SSH KEY file here
    ssh_private_key_file = "~/.ssh/id_rsa"

    # Raise the timeout, when installation takes longer
    

    cloud_init                          = local.cloud_init
    cloud_init_disk_type                = local.cloud_init_disk_type
    cloud_init_storage_pool             = local.cloud_init_storage_pool
    cloud_init_disable_upgrade_packages = local.cloud_init_disable_upgrade_packages
}

# Build Definition to create the VM Template
build {
    name    = "ubuntu-2604"
    sources = ["source.proxmox-iso.ubuntu"]

    provisioner "shell" {
        execute_command = "sudo -E sh -eux '{{.Path}}'"
        environment_vars = [
        "BUILD_USER=${var.build_username}",
        ]
        scripts = [
        "${path.root}/scripts/00-wait-cloud-init.sh",
        "${path.root}/scripts/10-provision.sh",
        "${path.root}/scripts/99-cleanup.sh",
        ]
        timeout = "45m"
    }

    post-processor "manifest" {
        output     = "${path.root}/manifest.json"
        strip_path = true
    }
}