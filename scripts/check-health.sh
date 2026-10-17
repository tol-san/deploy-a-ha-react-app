
#!/usr/bin/env bash
set -euo pipefail

PORT=3000
FAILED=0

SERVERS=(
    "web-01:192.168.56.20"
    "web-02:192.168.56.21"
)

check_server() {
    local name="$1"
    local ip="$2"
    local url="http://${ip}:${PORT}/health"
    local status

    status=$(curl -sS -o /dev/null \
        -w "%{http_code}" \
        --max-time 5 "$url") || status="000"

    if [[ "$status" == "200" ]]; then
        echo "[UP]   $name ($ip) HTTP $status"
        return 0
    else
        echo "[DOWN] $name ($ip) HTTP $status"
        return 1
    fi
}

echo "=== React Backend Health Check ==="

for server in "${SERVERS[@]}"; do
    name="${server%%:*}"
    ip="${server#*:}"

    if ! check_server "$name" "$ip"; then
        FAILED=1
    fi
done

exit "$FAILED"
