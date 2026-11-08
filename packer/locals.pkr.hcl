# Инварианты шаблона. Это не пользовательские настройки: они должны
# совпадать с тем, как собирается и используется образ.
locals {
  ssh_public_key = trimspace(file(pathexpand(var.ssh_public_key)))
  build_ip       = split("/", var.build_ip_cidr)[0]

  cpu_type        = "x86-64-v2-AES"
  bios            = "seabios"
  machine         = "pc"
  os_type         = "l26"
  cpu_sockets     = 1
  scsi_controller = "virtio-scsi-single"
  qemu_agent      = true
  boot_order      = "order=scsi0;ide2"

  disk_type      = "scsi"
  disk_format    = "raw"
  disk_io_thread = true
  disk_discard   = true
  disk_ssd       = true

  network_model    = "virtio"
  network_firewall = false

  boot_iso_type       = "ide"
  boot_iso_index      = "2"
  boot_iso_unmount    = true
  boot_iso_keep_cdrom = false

  cloud_init                          = true
  cloud_init_disk_type                = "ide"
  cloud_init_storage_pool             = "local-lvm"
  cloud_init_disable_upgrade_packages = true

  ssh_handshake_attempts = 200
  boot_key_interval      = "50ms"
}
