
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/vagrant/react-app"
BUN="/home/vagrant/.bun/bin/bun"

log() {
    echo "[SETUP] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

log "Installing required utilities..."

sudo apt-get update
sudo apt-get install -y curl unzip ca-certificates

if [[ ! -x "$BUN" ]]; then
    log "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
fi

[[ -x "$BUN" ]] || error "Bun installation failed"
[[ -f "$APP_DIR/package.json" ]] || error "React project not found"

cd "$APP_DIR"

if [[ ! -f node_modules/vite/bin/vite.js ]]; then
    log "Installing project dependencies..."
    "$BUN" install --backend=copyfile
else
    log "Vite dependencies already exist"
fi

log "Web environment ready!"
"$BUN" --version
