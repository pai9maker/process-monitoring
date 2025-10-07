#!/bin/bash

set -e

echo "Uninstalling process monitoring system..."

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Останавливаем и отключаем сервисы
systemctl stop monitoring.timer 2>/dev/null || true
systemctl disable monitoring.timer 2>/dev/null || true
systemctl daemon-reload

# Удаляем файлы
rm -f /usr/local/bin/monitoring.sh
rm -f /etc/systemd/system/monitoring.service
rm -f /etc/systemd/system/monitoring.timer
rm -f /var/run/monitoring.status 2>/dev/null || true

echo "Uninstallation completed successfully!"
