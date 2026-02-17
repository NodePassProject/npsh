#!/bin/sh
set -e
INSTALL_DIR=/etc/nodepass
BIN=$INSTALL_DIR/nodepass
CFG=$INSTALL_DIR/nodepass.conf
SERVICE=/etc/systemd/system/nodepass.service
REPO=NodePassProject/nodepass
die() { echo "Error: $1" >&2; exit 1; }
need_root() { [ "$(id -u)" -eq 0 ] || die "root required"; }
get_latest_version() { curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | cut -d'"' -f4; }
get_arch() { case "$(uname -m)" in x86_64) echo amd64;; aarch64|arm64) echo arm64;; *) die "unsupported arch: $(uname -m)";; esac; }
download_binary() {
    local ver=$(get_latest_version) arch=$(get_arch) os=$(uname -s | tr '[:upper:]' '[:lower:]')
    echo "Downloading nodepass $ver ..."
    curl -fsSL "https://github.com/$REPO/releases/download/$ver/nodepass_${os}_${arch}.tar.gz" -o /tmp/nodepass.tar.gz
    tar -xzf /tmp/nodepass.tar.gz -C "$(dirname "$BIN")" && chmod +x "$BIN" && rm -f /tmp/nodepass.tar.gz
}
install_service() {
    cat > "$SERVICE" <<EOF
[Unit]
Description=NodePass Master
After=network.target
[Service]
ExecStart=$BIN "\$(cat $CFG)"
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload && systemctl enable nodepass
}

cmd_install() {
    need_root || die "root required"
    command -v curl >/dev/null || die "curl not found"
    command -v systemctl >/dev/null || die "systemd not found"
    [ -f "$BIN" ] && die "already installed, use: $0 update"
    mkdir -p "$INSTALL_DIR"
    printf "Listen address [0.0.0.0]: "; read -r addr; addr=${addr:-0.0.0.0}
    printf "Listen port [1024]: "; read -r port; port=${port:-1024}
    printf "API prefix (optional): "; read -r prefix
    printf "TLS level (0=none 1=self-signed 2=custom) [0]: "; read -r tls; tls=${tls:-0}
    query="tls=$tls"
    [ "$tls" = "2" ] && {
        printf "Certificate file path: "; read -r crt
        printf "Private key file path: "; read -r key
        [ -f "$crt" ] || die "cert file not found: $crt"
        [ -f "$key" ] || die "key file not found: $key"
        query="$query&crt=$crt&key=$key"
    }
    echo "master://$addr:$port$prefix?$query" > "$CFG"
    download_binary && install_service && systemctl start nodepass
    sleep 1
    scheme="http"; [ "$tls" != "0" ] && scheme="https"
    apikey=$(journalctl -u nodepass -n 50 --no-pager 2>/dev/null | grep "API Key" | tail -1 | grep -oE '[0-9a-f-]{36}' || true)
    echo "" && echo "=== NodePass Installed ===" && echo "API URL : $scheme://$addr:$port$prefix/v1"
    [ -n "$apikey" ] && echo "API Key : $apikey"
    echo "Log     : journalctl -fu nodepass"
}

cmd_start() { need_root; systemctl start nodepass && echo "started"; }
cmd_stop() { need_root; systemctl stop nodepass && echo "stopped"; }
cmd_status() { systemctl status nodepass; }
cmd_update() { need_root; [ -f "$BIN" ] || die "not installed"; systemctl stop nodepass 2>/dev/null || true; download_binary && systemctl start nodepass && echo "updated"; }
cmd_uninstall() { need_root; printf "Uninstall nodepass and remove all data? [y/N]: " && read -r confirm && echo "$confirm" | grep -qE '^[yY]$' || { echo "aborted"; exit 0; }; systemctl stop nodepass 2>/dev/null || true; systemctl disable nodepass 2>/dev/null || true; rm -f "$SERVICE" && systemctl daemon-reload && rm -rf "$INSTALL_DIR" && echo "uninstalled"; }

case "${1:-}" in
    install|start|stop|status|update|uninstall) cmd_$1 ;;
    *) echo "Usage: $0 {install|start|stop|status|update|uninstall}"; exit 1 ;;
esac
