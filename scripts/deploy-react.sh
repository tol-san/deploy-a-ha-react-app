
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/vagrant/react-app"
BUN="/home/vagrant/.bun/bin/bun"
SERVICE="react-app"

log() {
    echo "[DEPLOY] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

[[ -f "$APP_DIR/package.json" ]] || error "Project not found"
[[ -f "$APP_DIR/node_modules/vite/bin/vite.js" ]] || error "Vite not installed"
[[ -x "$BUN" ]] || error "Bun not installed"

cd "$APP_DIR"

log "Building React application..."
"$BUN" --bun node_modules/vite/bin/vite.js build

[[ -f dist/index.html ]] || error "Build failed"

log "Restarting React service..."
sudo systemctl restart "$SERVICE"

sleep 2

if ! systemctl is-active --quiet "$SERVICE"; then
    error "React service failed to start"
fi

log "Checking HTTP health..."

if ! curl -fsS --max-time 5 \
    http://127.0.0.1:3000/health -o /dev/null; then
    error "Application health check failed"
fi

log "Deployment successful!"
