#!/usr/bin/env bash
# Первичная настройка образа. Выполняется Packer'ом по SSH под sudo.
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

apt-get update
apt-get -y   -o Dpkg::Options::="--force-confdef"   -o Dpkg::Options::="--force-confold"   dist-upgrade

apt-get -y install   qemu-guest-agent   cloud-init   cloud-guest-utils   chrony   ca-certificates   curl   jq   unattended-upgrades   sudo   openssh-server

# PVE передаёт NoCloud seed через SMBIOS. Фиксируем порядок datasource,
# чтобы cloud-init не искал EC2/GCE на клонах.
cat >/etc/cloud/cloud.cfg.d/99-pve-datasource.cfg <<'CFG_EOF'
datasource_list: [ NoCloud, ConfigDrive, None ]
CFG_EOF

# Subiquity создаёт этот файл и запрещает cloud-init менять сеть.
# Клонам сеть выдаёт PVE через cloud-init, поэтому файл нужно убрать.
rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg

systemctl enable qemu-guest-agent
systemctl enable chrony
systemctl enable ssh

# Страховка: пакет агента должен быть реально установлен.
dpkg -s qemu-guest-agent >/dev/null
