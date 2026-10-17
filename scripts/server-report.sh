
#!/usr/bin/env bash
set -euo pipefail

show_report() {
    echo "================================"
    echo "        SERVER REPORT"
    echo "================================"

    echo "Hostname:"
    hostname

    echo
    echo "IP Addresses:"
    ip -br -4 addr

    echo
    echo "Uptime:"
    uptime -p

    echo
    echo "Memory Usage:"
    free -h

    echo
    echo "CPU Information:"
    nproc
    echo "CPU usage snapshot:"
    top -bn1 | grep -m1 'Cpu(s)' || echo "CPU usage unavailable"

    echo
    echo "Disk Usage:"
    df -h /

    echo
    echo "================================"
}

show_report
