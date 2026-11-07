#!/usr/bin/env bash
# Подготовка шаблона: удаляем всё, что делает клоны одинаковыми.
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

# --- сеть -----------------------------------------------------------------
# Клон получит сетевую конфигурацию от cloud-init PVE.
rm -f /etc/netplan/*.yaml
rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg

# --- пакеты ---------------------------------------------------------------
apt-get -y autoremove --purge
apt-get -y clean
rm -rf /var/lib/apt/lists/*

# --- идентичность ---------------------------------------------------------
cloud-init clean --logs --seed || true
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
rm -f /etc/ssh/ssh_host_*
rm -rf /var/lib/cloud
rm -f /var/log/cloud-init.log /var/log/cloud-init-output.log
rm -rf /var/lib/systemd/random-seed

# --- история и мусор ------------------------------------------------------
rm -f /root/.bash_history
find /home -maxdepth 2 -name '.bash_history' -delete
rm -f /var/log/wtmp /var/log/lastlog

# --- build-пользователь ---------------------------------------------------
# Пароль заблокирован (вход только по запечённому SSH-ключу).
# sudo NOPASSWD оставлен осознанно: ключ = root-доступ, как в cloud-образах.
usermod -L "${BUILD_USER:-ubuntu}" || true

fstrim -av || true
sync
