#!/usr/bin/env sh
# BSD-compatible NodePass installer script with bilingual UI, auto-detect, flexible config, TLS, container support
SCRIPT_VERSION='0.2.0'

# Paths
TEMP_DIR=$(mktemp -d /tmp/nodepass.XXXX)
WORK_DIR='/usr/local/etc/nodepass'
INSTALL_BIN='/usr/local/bin/nodepass'
RC_SCRIPT='/usr/local/etc/rc.d/nodepass'
PID_FILE='/var/run/nodepass.pid'
LOG_FILE='/var/log/nodepass.log'
SHORTCUT_DIR='/usr/local/bin'

# GitHub API
REPO='NodePassProject/NodePass'
API_URL="https://api.github.com/repos/$REPO/releases/latest"

# Default config
PORT=8080
API_PREFIX='/api'
TLS_MODE='none'  # none, self, custom
TLS_CERT='' TLS_KEY=''
LANG=${LANG%%_*}  # zh or en default

# Translation
t() { case "$LANG" in zh) echo "$2" ;; *) echo "$1" ;; esac; }

echo_b() { t "$1" "$2" >&2; }

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT INT TERM

# Pre-check root
[ "$(id -u)" -eq 0 ] || echo_b "Error: run as root." "错误：请使用 root 运行。" && exit 1

# Auto-detect architecture
ARCH=$(uname -m)
OS=$(uname | tr '[:upper:]' '[:lower:]')
if [ "$ARCH" = 'x86_64' ]; then ARCH='amd64'; fi

# Detect container
if grep -qE '/docker|/lxc' /proc/1/cgroup 2>/dev/null; then IN_CONTAINER=1; else IN_CONTAINER=0; fi

# Check deps
for cmd in sh curl tar sysrc service openssl; do
  command -v $cmd >/dev/null 2>&1 || echo_b "Error: missing $cmd." "错误：缺少 $cmd。" && exit 1
 done

# Fetch latest tag
get_latest() { curl -s "$API_URL" | grep -Po '"tag_name": "v?[0-9\.]+"' | head -1 | cut -d '"' -f4; }

download_pkg() {
  VER=$(get_latest) || return 1
  URL="https://github.com/$REPO/releases/download/$VER/nodepass_${VER#v}_${OS}_${ARCH}.tar.gz"
  curl -sL "$URL" | tar xz -C "$TEMP_DIR"
  echo $VER
}

# Generate rc.d
install_rc() {
  cat > "$RC_SCRIPT" <<- EOF
#!/bin/sh
# PROVIDE: nodepass
# REQUIRE: DAEMON
. /etc/rc.subr
name="nodepass"
rcvar=nodepass_enable
command="$INSTALL_BIN"
pidfile="$PID_FILE"
start_cmd="nodepass_start"
stop_cmd="nodepass_stop"
nodepass_start() {
  mkdir -p "$WORK_DIR"
  \$command --dir "$WORK_DIR" --port $PORT --prefix $API_PREFIX \$TLS_ARGS >> "$LOG_FILE" 2>&1 &
  echo \$! > \$pidfile
}
nodepass_stop() { kill \$(cat \$pidfile); }
load_rc_config \$name
: \${nodepass_enable:="NO"}
run_rc_command "$1"
EOF
  chmod +x "$RC_SCRIPT"
  sysrc nodepass_enable=YES
}

# Create shortcuts
create_shortcuts() {
  for cmd in start stop restart install uninstall upgrade; do
    ln -sf "$INSTALL_BIN" "$SHORTCUT_DIR/nodepass-$cmd"
  done
}

install() {
  echo_b "Installing NodePass..." "正在安装 NodePass..."
  download_pkg || exit 1
  install -o root -g wheel -m 755 "$TEMP_DIR/nodepass" "$INSTALL_BIN"
  mkdir -p "$WORK_DIR"
  set_tls_args
  install_rc
  service nodepass start
  create_shortcuts
  echo_b "Installed version $VER." "已安装版本 $VER。"
}

uninstall() {
  echo_b "Uninstalling..." "正在卸载..."
  service nodepass stop 2>/dev/null
  sysrc -x nodepass_enable
  rm -f "$INSTALL_BIN" "$RC_SCRIPT"
  rm -rf "$WORK_DIR" "$PID_FILE"
  for cmd in start stop restart install uninstall upgrade; do rm -f "$SHORTCUT_DIR/nodepass-$cmd"; done
  echo_b "Uninstalled." "卸载完成。"
}

toggle() { service nodepass onestatus >/dev/null 2>&1 && service nodepass stop || service nodepass start; }

restart() { service nodepass restart; }

upgrade() { echo_b "Upgrading..." "正在升级..."; uninstall; install; }

change_key() {
  cfg="$WORK_DIR/config.json"
  [ -f "$cfg" ] || echo_b "Not installed." "未安装。" && exit 1
  NEW=$(openssl rand -hex 16)
  sed -i '' -E "s/\"api_key\": \"[0-9a-f]+\"/\"api_key\": \"$NEW\"/" "$cfg"
  echo_b "New API key: $NEW" "新的 API 密钥：$NEW"
}

show_info() {
  cfg="$WORK_DIR/config.json"
  [ -f "$cfg" ] || echo_b "Not installed." "未安装。" && exit 1
  echo_b "API info:" "API 信息："
  grep -E 'url|key' "$cfg"
}

set_tls_args() {
  case "$TLS_MODE" in
    none) TLS_ARGS="";;
    self) TLS_ARGS="--tls --tls-self";;
    custom) TLS_ARGS="--tls --tls-cert $TLS_CERT --tls-key $TLS_KEY";;
    *) TLS_ARGS="";;
  esac
}

usage() {
  echo_b \
  "Usage: $0 [options] {-i|-u|-o|-r|-v|-k|-s|-h}" \
  "用法：$0 [选项] {-i|-u|-o|-r|-v|-k|-s|-h}" && exit 1
}

# Parse args
while getopts ":iurvoks:p:f:t:T:L:h" opt; do
  case "$opt" in
    i) CMD=install;; u) CMD=uninstall;; o) CMD=toggle;; r) CMD=restart;; v) CMD=upgrade;; k) CMD=change_key;; s) CMD=show_info;;
    p) PORT=$OPTARG;; f) API_PREFIX=$OPTARG;;
    t) TLS_MODE=$OPTARG;; T) TLS_CERT=$OPTARG;;  L) TLS_KEY=$OPTARG;;
    h) usage;; *) usage;;
  esac
done
shift $((OPTIND-1))

[ -n "$CMD" ] || usage
eval "$CMD"
