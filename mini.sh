#!/bin/sh
set -e
D=/etc/nodepass B=$D/nodepass C=$D/nodepass.conf S=/etc/systemd/system/nodepass.service R=NodePassProject/nodepass
die() { echo "Error: $1" >&2; exit 1; }
root() { [ "$(id -u)" -eq 0 ] || die "root required"; }
ver() { curl -fsSL "https://api.github.com/repos/$R/releases/latest" | grep '"tag_name"' | cut -d'"' -f4; }
arch() { case "$(uname -m)" in x86_64) echo amd64;; aarch64|arm64) echo arm64;; *) die "unsupported arch";; esac; }

dl() {
    v=$(ver); n=${v#v}; a=$(arch); o=$(uname -s | tr '[:upper:]' '[:lower:]')
    echo "Downloading nodepass $v ..."
    curl -fsSL "https://github.com/$R/releases/download/$v/nodepass_${n}_${o}_${a}.tar.gz" | tar -xzC $D
    chmod +x $B
}

svc() {
    cat >$S <<'E'
[Unit]
Description=NodePass Master
After=network.target
[Service]
ExecStart=/bin/sh -c 'exec /etc/nodepass/nodepass "$(cat /etc/nodepass/nodepass.conf)"'
WorkingDirectory=/etc/nodepass
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
E
    systemctl daemon-reload && systemctl enable nodepass
}

install() {
    root
    command -v curl >/dev/null || die "curl not found"
    command -v systemctl >/dev/null || die "systemd not found"
    [ -f "$B" ] && die "already installed, use: $0 update"
    mkdir -p $D
    printf "Listen address [0.0.0.0]: "; read -r addr; addr=${addr:-0.0.0.0}
    printf "Listen port [1024]: "; read -r port; port=${port:-1024}
    printf "API prefix (optional): "; read -r pfx
    printf "TLS (0=none 1=self-signed 2=custom) [1]: "; read -r tls; tls=${tls:-1}
    q="tls=$tls"
    [ "$tls" = "2" ] && {
        printf "Cert path: "; read -r crt
        printf "Key path: "; read -r key
        [ -f "$crt" ] && [ -f "$key" ] || die "cert/key not found"
        q="$q&crt=$crt&key=$key"
    }
    echo "master://$addr:$port$pfx?$q" >$C
    dl && svc && systemctl start nodepass
    sleep 1
    s=http; [ "$tls" != "0" ] && s=https
    k=$(journalctl -u nodepass -n 50 --no-pager 2>/dev/null | grep "API Key created:" | tail -1 | grep -oE '[0-9a-f]{32}')
    echo "=== NodePass Installed ==="
    echo "URL: $s://$addr:$port$pfx/v1"
    [ -n "$k" ] && echo "Key: $k"
    echo "Log: journalctl -fu nodepass"
}

start() { root; systemctl start nodepass && echo "started"; }
stop() { root; systemctl stop nodepass && echo "stopped"; }
status() { systemctl status nodepass; }

update() {
    root; [ -f "$B" ] || die "not installed"
    systemctl stop nodepass 2>/dev/null || true
    dl && systemctl start nodepass && echo "updated"
}

uninstall() {
    root
    printf "Uninstall nodepass and remove all data? [y/N]: "; read -r x
    echo "$x" | grep -qE '^[yY]$' || { echo "aborted"; exit 0; }
    systemctl stop nodepass 2>/dev/null || true
    systemctl disable nodepass 2>/dev/null || true
    rm -f $S && systemctl daemon-reload && rm -rf $D && echo "uninstalled"
}

case "${1:-}" in
    install|start|stop|status|update|uninstall) $1 ;;
    *) echo "Usage: {install|start|stop|status|update|uninstall}"; exit 1 ;;
esac
