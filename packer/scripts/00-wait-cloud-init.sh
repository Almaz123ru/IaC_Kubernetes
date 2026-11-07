#!/usr/bin/env bash
# Packer подключается по SSH раньше, чем cloud-init полностью завершится.
# Ждём boot-finished, но не бесконечно.
set -euo pipefail

echo "Waiting for cloud-init to finish..."

timeout 600 sh -c '
  while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
    sleep 2
  done
'

echo "cloud-init finished."