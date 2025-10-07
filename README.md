# Process Monitoring System

Система мониторинга процесса test для Linux с использованием systemd.

# Функциональность

- Мониторинг процесса каждую минуту
- Автозапуск при старте системы  
- HTTPS проверка сервера мониторинга
- Логирование перезапусков процесса
- Логирование недоступности сервера

# Структура проекта
process-monitoring/
│
├── src/
│   ├── monitoring.sh
│   ├── monitoring.service
│   ├── monitoring.timer
│   ├── install_monitoring.sh
│   └── uninstall_monitoring.sh
│
├── examples/
│   └── test-process-example.sh
│
└── README.md

# Быстрая установка

```bash
git clone https://github.com/your-username/process-monitoring.git
cd process-monitoring/src
chmod +x install_monitoring.sh
sudo ./install_monitoring.sh

Логи
Логи сохраняются в /var/log/monitoring.log

Управление сервисом
bash
# Статус таймера
sudo systemctl status monitoring.timer

# Логи сервиса
sudo journalctl -u monitoring.service

# Просмотр логов мониторинга
sudo tail -f /var/log/monitoring.log
