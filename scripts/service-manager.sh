
#!/usr/bin/env bash
set -euo pipefail

SERVICE="react-app"

usage() {
    echo "Usage: $0 {start|stop|restart|status}"
}

manage_service() {
    local action="$1"

    case "$action" in
        start)
            sudo systemctl start "$SERVICE"
            ;;
        stop)
            sudo systemctl stop "$SERVICE"
            ;;
        restart)
            sudo systemctl restart "$SERVICE"
            ;;
        status)
            systemctl status "$SERVICE" --no-pager
            ;;
        *)
            usage
            return 2
            ;;
    esac
}

if [[ $# -ne 1 ]]; then
    usage
    exit 2
fi

manage_service "$1"
