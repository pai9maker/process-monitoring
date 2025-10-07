#!/bin/bash

set -e

echo "Installing process monitoring system..."

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Копируем скрипт мониторинга
cp monitoring.sh /usr/local/bin/monitoring.sh
chmod 755 /usr/local/bin/monitoring.sh

# Копируем systemd unit файлы
cp monitoring.service /etc/systemd/system/
cp monitoring.timer /etc/systemd/system/
chmod 644 /etc/systemd/system/monitoring.service /etc/systemd/system/monitoring.timer

# Создаем лог файл
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log

# Перезагружаем systemd
systemctl daemon-reload

# Включаем и запускаем таймер
systemctl enable monitoring.timer
systemctl start monitoring.timer

echo "Installation completed successfully!"
echo "Check status: systemctl status monitoring.timer"
echo "View logs: journalctl -u monitoring.service"
