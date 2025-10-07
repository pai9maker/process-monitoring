#!/bin/bash

# Скрипт мониторинга процесса test
LOG_FILE="/var/log/monitoring.log"
MONITORING_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test"
STATUS_FILE="/var/run/monitoring.status"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    logger -t "process-monitoring" "$1"
}

check_process() {
    pgrep -x "$PROCESS_NAME" > /dev/null 2>&1
    return $?
}

check_monitoring_server() {
    curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 15 "$MONITORING_URL" 2>/dev/null
}

get_previous_status() {
    if [[ -f "$STATUS_FILE" ]]; then
        cat "$STATUS_FILE"
    else
        echo "unknown"
    fi
}

save_current_status() {
    echo "$1" > "$STATUS_FILE"
}

main() {
    local current_status
    local previous_status
    local http_code
    
    if check_process; then
        current_status="running"
        http_code=$(check_monitoring_server)
        
        if [[ "$http_code" =~ ^2[0-9][0-9]$|^3[0-9][0-9]$ ]]; then
            log_message "INFO: Process $PROCESS_NAME is running. Monitoring server responded with HTTP $http_code"
        else
            log_message "ERROR: Process $PROCESS_NAME is running but monitoring server is not available (HTTP $http_code)"
        fi
    else
        current_status="stopped"
    fi
    
    previous_status=$(get_previous_status)
    
    if [[ "$previous_status" == "stopped" && "$current_status" == "running" ]]; then
        log_message "INFO: Process $PROCESS_NAME was restarted"
    elif [[ "$previous_status" == "running" && "$current_status" == "stopped" ]]; then
        log_message "INFO: Process $PROCESS_NAME was stopped"
    fi
    
    save_current_status "$current_status"
}

main "$@"
