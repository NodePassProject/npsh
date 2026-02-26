#!/bin/bash

# 更新时间 2025-11-24

# 定义颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无色

# 函数：显示帮助信息
show_help() {
  echo -e "${GREEN}NodePassDash 管理脚本使用说明${NC}"
  echo -e "================================"
  echo -e "${YELLOW}可用参数:${NC}"
  echo -e "  ${GREEN}install${NC}     - 安装/配置 NodePassDash"
  echo -e "  ${GREEN}update${NC}      - 检查并更新 NodePassDash 到最新版本"
  echo -e "  ${GREEN}resetpwd${NC}    - 重置管理员密码"
  echo -e "  ${GREEN}uninstall${NC}   - 卸载 NodePassDash"
  echo -e "  ${GREEN}help${NC}        - 显示此帮助信息"
  echo -e ""
  echo -e "${YELLOW}使用示例:${NC}"
  echo -e "  ${GREEN}./dash.sh install${NC}   # 正常安装"
  echo -e "  ${GREEN}./dash.sh update${NC}    # 更新到最新版本"
  echo -e "  ${GREEN}./dash.sh resetpwd${NC}  # 重置管理员密码"
  echo -e "  ${GREEN}./dash.sh uninstall${NC} # 卸载 NodePassDash"
  echo -e "  ${GREEN}./dash.sh help${NC}      # 显示帮助信息"
  exit 0
}

# 函数：检查并安装 curl 或 wget
check_download_cmd() {
  # 检查并安装 curl
  if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    echo -e "${GREEN}curl 和 wget 都未安装，正在安装 curl...${NC}"
    if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
      apt update >/dev/null 2>&1
      apt install -y curl >/dev/null 2>&1
    elif [ "$OS" == "centos" ]; then
      yum install -y curl >/dev/null 2>&1
    fi
  fi

  # 选择使用 wget 或 curl
  if command -v wget &>/dev/null; then
    DOWNLOAD_CMD="wget -qO-"
  else
    DOWNLOAD_CMD="curl -fsSL"
  fi
}

# 函数：统计脚本运行次数
statistics_of_run-times() {
  local STATS=$($DOWNLOAD_CMD "https://stat.cloudflare.now.cc/api/updateStats?script=dash.sh")
  [[ "$STATS" =~ \"todayCount\":([0-9]+),\"totalCount\":([0-9]+) ]] && TODAY="${BASH_REMATCH[1]}" && TOTAL="${BASH_REMATCH[2]}"
}

# 函数：检测操作系统类型
check_os() {
  # 检测操作系统类型
  if [ -f /etc/debian_version ]; then
    OS="debian"
  elif [ -f /etc/lsb-release ]; then
    OS="ubuntu"
  elif [ -f /etc/redhat-release ]; then
    OS="centos"
  else
    echo -e "${RED}不支持的操作系统${NC}"
    exit 1
  fi
}

# 函数：检查域名或IP地址格式
validate_input() {
  local input=$1
  # 检查是否是有效的IPv4地址
  if [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  # 检查是否是有效的IPv6地址
  elif [[ $input =~ ^[0-9a-fA-F:]+$ ]]; then
    return 0
  # 检查是否是有效的域名
  elif [[ $input =~ ^[a-zA-Z0-9.-]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# 函数：检查端口是否在有效范围内
validate_port() {
  local port=$1

  if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo -e "${RED}错误：端口号 $port 无效。请提供一个在 1 到 65535 之间的端口号。${NC}"
    return 1
  fi

  # 如果需要检查 Caddy 端口冲突（当 TLS_MODE 不为 2 时）
  if [ "$TLS_MODE" != "2" ]; then
    if [ "$port" == "80" ] || [ "$port" == "443" ] || [ "$port" == "2019" ]; then
      echo -e "${RED}错误：端口 $port 会被 Caddy 占用，请选择其他端口。${NC}"
      return 1
    fi
  fi

  return 0
}

# 函数：重置管理员密码
reset_admin_password() {
  # 检查容器是否运行
  if ! $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
    echo -e "${RED}错误：nodepassdash 容器未运行，无法重置密码。${NC}"
    exit 1
  fi

  echo -e "${GREEN}正在重置管理员密码...${NC}"

  # 直接执行命令并捕获输出
  $CONTAINER_CMD exec -it nodepassdash /app/nodepassdash -resetpwd

  # 重启容器让新密码生效
  if $CONTAINER_CMD restart nodepassdash &>/dev/null; then
    exit 0
  else
    echo -e "${RED}错误：nodepassdash 容器未重启成功，无法重置密码。${NC}"
    exit 1
  fi
}

# 函数：检查并更新 NodePassDash
update_nodepassdash() {
  # 检查容器是否运行
  if ! $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
    echo -e "${RED}错误：nodepassdash 容器未运行，无法更新。${NC}"
    exit 1
  fi

  # 获取本地版本
  local LOCAL_VERSION=$($CONTAINER_CMD exec -it nodepassdash /app/nodepassdash -v 2>/dev/null | awk '/NodePassDash/{gsub(/\r/,"",$NF); print $NF}')
  if [ -z "$LOCAL_VERSION" ]; then
    echo -e "${RED}无法获取本地版本。${NC}"
    exit 1
  fi

  # 获取远程版本
  local REMOTE_VERSION=$(curl -s https://api.github.com/repos/NodePassProject/NodePassDash/releases/latest | awk -F '"' '/"tag_name"/{print $4}' | sed "s/[Vv]//")
  if [ -z "$REMOTE_VERSION" ]; then
    echo -e "${RED}无法获取远程版本。${NC}"
    exit 1
  fi

  # 显示版本信息
  echo -e "${GREEN}本地版本: $LOCAL_VERSION${NC}"
  echo -e "${GREEN}远程版本: $REMOTE_VERSION${NC}"

  # 比较版本
  if [ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]; then
    echo -e "${GREEN}当前已是最新版本，无需更新。${NC}"
    exit 0
  else
    echo -e "${YELLOW}发现新版本 $REMOTE_VERSION (当前版本 $LOCAL_VERSION)${NC}"
    read -p "$(echo -e ${YELLOW}是否要更新到最新版本? [y/N]: ${NC})" choice
    case "$choice" in
    y | Y)
      echo -e "${GREEN}正在准备更新...${NC}"
      ;;
    *)
      echo -e "${GREEN}已取消更新。${NC}"
      exit 0
      ;;
    esac
  fi

  # 检查并安装 watchtower
  if ! $CONTAINER_CMD inspect watchtower &>/dev/null; then
    echo -e "${GREEN}正在临时运行 watchtower 容器进行更新...${NC}"
    $CONTAINER_CMD run --rm \
      -v /var/run/$CONTAINER_CMD.sock:/var/run/$CONTAINER_CMD.sock \
      -e DOCKER_API_VERSION=1.44 \
      containrrr/watchtower \
      --run-once \
      --cleanup \
      nodepassdash
  else
    echo -e "${GREEN}正在使用已安装的 watchtower 进行更新...${NC}"
    $CONTAINER_CMD start watchtower
  fi

  # 等待更新完成
  echo -e "${YELLOW}正在更新，请稍候...${NC}"
  sleep 10

  # 验证更新是否成功
  local NEW_VERSION=$($CONTAINER_CMD exec -it nodepassdash /app/nodepassdash -v 2>/dev/null | awk '/NodePassDash/{gsub(/\r/,"",$NF); print $NF}')
  if [ "$NEW_VERSION" == "$REMOTE_VERSION" ]; then
    echo -e "${GREEN}更新成功！当前版本: $NEW_VERSION${NC}"
  else
    echo -e "${RED}更新失败，请检查日志。${NC}"
    exit 1
  fi

  exit 0
}

# 函数：卸载 NodePassDash
uninstall_nodepassdash() {
  if $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
    echo -e "${GREEN}正在停止并删除 nodepassdash 容器...${NC}"
    $CONTAINER_CMD stop nodepassdash >/dev/null 2>&1
    $CONTAINER_CMD rm nodepassdash >/dev/null 2>&1
    rm -rf ~/nodepassdash
    $CONTAINER_CMD rmi ghcr.io/nodepassproject/nodepassdash:latest >/dev/null 2>&1
    echo -e "${GREEN}nodepassdash 容器已成功卸载。${NC}"
  else
    echo -e "${RED}未找到 nodepassdash 容器，无法卸载。${NC}"
  fi
  exit 0
}

# 检查是否以管理员权限运行
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}请以管理员权限运行此脚本。${NC}"
  exit 1
fi

# 检测容器管理工具并设置变量（只判断一次）
if command -v podman &>/dev/null; then
  CONTAINER_CMD="podman"
  echo -e "${GREEN}检测到 Podman，将使用 Podman 作为容器管理工具${NC}"
elif command -v docker &>/dev/null; then
  CONTAINER_CMD="docker"
  echo -e "${GREEN}检测到 Docker，将使用 Docker 作为容器管理工具${NC}"
else
  echo -e "${GREEN}未检测到容器管理工具，将尝试安装 Docker...${NC}"
  CONTAINER_CMD="docker" # 设置为默认值，后续会安装
fi

# 安装容器运行时的函数
install_container_runtime() {
  echo -e "${GREEN}正在安装 Docker...${NC}"
  # 检测不能安装容器的旧操作系统
  if [ "$OS" = "centos" ]; then
    # 检查 CentOS 版本
    CENTOS_VERSION=$(rpm -E '%{rhel}')
    if [ "$CENTOS_VERSION" -lt 8 ]; then
      echo -e "${RED}错误：您的 CentOS 版本 $CENTOS_VERSION 过低。请使用 CentOS 8 或 9 版本。${NC}"
      exit 1
    fi
  fi

  # 使用官方脚本安装 Docker
  bash <($DOWNLOAD_CMD get.docker.com) >/dev/null 2>&1
  # 启动 Docker 并开启 IPv6
  systemctl start docker >/dev/null 2>&1
  systemctl enable docker >/dev/null 2>&1
  echo -e "${GREEN}Docker 安装完成，正在开启 IPv6...${NC}"

  # 检查是否存在 daemon.json，如果存在则备份
  DAEMON_JSON="/etc/docker/daemon.json"
  if [ -f $DAEMON_JSON ]; then
    echo -e "${GREEN}检测到已有 daemon.json，正在备份为 daemon.json.bak...${NC}"
    cp $DAEMON_JSON $DAEMON_JSON.bak
    echo -e "${GREEN}备份完成。${NC}"
  fi

  # 创建新的 daemon.json
  cat >$DAEMON_JSON <<EOF
{
  "ipv6": true,
  "fixed-cidr-v6": "fd00::/80",
  "experimental": true,
  "ip6tables": true
}
EOF
  echo -e "${GREEN}daemon.json 已创建，内容如下：${NC}"
  cat $DAEMON_JSON

  # 重启 Docker 服务
  systemctl restart docker >/dev/null 2>&1
  CONTAINER_CMD="docker"
  echo -e "${GREEN}Docker 服务已重启。${NC}"
}

# 安装主程序
install_nodepassdash() {
  # 如果容器管理工具不存在且不是卸载操作，尝试安装
  if ! command -v $CONTAINER_CMD &>/dev/null && [[ "$1" != "uninstall" ]]; then
    install_container_runtime
  fi

  # 配置容器管理工具的IPv6支持（如果使用Podman）
  if [ "$CONTAINER_CMD" == "podman" ]; then
    # 检查并设置 Podman 的 IPv6 支持
    PODMAN_CONFIG_DIR="$HOME/.config/containers"
    mkdir -p "$PODMAN_CONFIG_DIR"
    PODMAN_CONF="$PODMAN_CONFIG_DIR/containers.conf"

    # 创建或更新 containers.conf 文件以启用 IPv6
    if ! grep -q 'enable_ipv6' "$PODMAN_CONF" 2>/dev/null; then
      echo -e "${GREEN}正在配置 Podman 以支持 IPv6...${NC}"
      {
        echo "[network]"
        echo "enable_ipv6 = true"
      } >>"$PODMAN_CONF"
    else
      echo -e "${GREEN}Podman 已配置为支持 IPv6。${NC}"
    fi
  fi

  # 询问用户输入域名或IP地址
  while true; do
    read -p "$(echo -e ${YELLOW}请输入域名或IPv4/IPv6地址（此项为必填）： ${NC})" INPUT
    if validate_input "$INPUT"; then
      echo -e "${GREEN}您输入的内容是: $INPUT${NC}"
      break
    else
      echo -e "${RED}输入无效，请输入有效的域名或IPv4/IPv6地址。${NC}"
    fi
  done

  # 检测 Caddy 是否已安装
  if ! [[ "$INPUT" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [[ "$INPUT" =~ ^[0-9a-fA-F:]+$ ]]; then
    # 询问用户选择 TLS 证书模式
    echo -e "${YELLOW}请选择 TLS 证书模式 (默认 1):${NC}"
    echo -e "${GREEN} 1. 使用 Caddy 自动申请证书 (默认)\n 2. 自定义 TLS 证书文件路径${NC}"
    read -p "$(echo -e ${YELLOW}请选择：${NC})" TLS_MODE
    TLS_MODE=${TLS_MODE:-1} # 默认为1

    if [ "$TLS_MODE" = "2" ]; then
      # 处理证书文件
      while true; do
        read -p "$(echo -e ${YELLOW}请输入您的 TLS 证书文件路径:${NC}) " CERT_FILE
        if [ -f "$CERT_FILE" ]; then
          break
        else
          echo -e "${RED}证书文件不存在: $CERT_FILE${NC}"
        fi
      done

      # 处理私钥文件
      while true; do
        read -p "$(echo -e ${YELLOW}请输入您的 TLS 私钥文件路径:${NC}) " KEY_FILE
        if [ -f "$KEY_FILE" ]; then
          break
        else
          echo -e "${RED}私钥文件不存在: $KEY_FILE${NC}"
        fi
      done

      echo -e "${GREEN}使用自定义 TLS 证书${NC}"
    fi

    # 如果 TLS 模式不是 2，则使用 Caddy 自动申请证书
    if [ "$TLS_MODE" != "2" ]; then
      if ! command -v caddy &>/dev/null; then
        echo -e "${GREEN}Caddy 未安装，正在安装...${NC}"
        if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
          apt update >/dev/null 2>&1
          apt install -y debian-keyring debian-archive-keyring >/dev/null 2>&1
          $DOWNLOAD_CMD 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --yes --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
          $DOWNLOAD_CMD 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null 2>&1
          apt update >/dev/null 2>&1
          apt install -y caddy >/dev/null 2>&1
        elif [ "$OS" == "centos" ]; then
          dnf install 'dnf-command(copr)' >/dev/null 2>&1
          dnf -y copr enable @caddy/caddy >/dev/null 2>&1
          dnf install -y caddy >/dev/null 2>&1
        fi

        # 检查 Caddy 安装是否成功
        if ! command -v caddy &>/dev/null; then
          echo -e "${RED}Caddy 安装失败，请检查错误信息。${NC}"
          exit 1
        else
          echo -e "${GREEN}Caddy 安装完成${NC}"
        fi
      else
        echo -e "${GREEN}Caddy 已安装${NC}"
      fi

      # 使用 Caddy 自动申请证书
      cat >>/etc/caddy/Caddyfile <<EOF

$INPUT {
    reverse_proxy localhost:$PORT
}
EOF

      # 重置 Caddy 配置
      caddy reload --config /etc/caddy/Caddyfile &>/dev/null
      [ "$?" = 0 ] && echo -e "${GREEN}$INPUT 的 Caddy 反代已生效${NC}"
    fi
  fi

  # 询问用户使用的端口，默认是3000
  while true; do
    read -p "$(echo -e ${YELLOW}请输入要使用的端口（默认3000）： ${NC})" PORT
    PORT=${PORT:-3000} # 如果未输入，则使用默认值3000

    # 验证端口
    if ! validate_port "$PORT" "$TLS_MODE"; then
      continue
    fi

    # 检查端口是否被占用
    if command -v lsof &>/dev/null; then
      if lsof -i:$PORT &>/dev/null; then
        echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
        continue
      fi
    elif command -v netstat &>/dev/null; then
      if netstat -tuln | grep ":$PORT" &>/dev/null; then
        echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
        continue
      fi
    elif command -v ss &>/dev/null; then
      if ss -tuln | grep ":$PORT" &>/dev/null; then
        echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
        continue
      fi
    else
      echo -e "${GREEN}未检测到 lsof、netstat 或 ss，正在安装 iproute2...${NC}"
      if [ "$OS" == "debian" ] || [ "$OS" == "ubuntu" ]; then
        apt update >/dev/null 2>&1
        apt install -y iproute2 >/dev/null 2>&1
      elif [ "$OS" == "centos" ]; then
        yum install -y iproute >/dev/null 2>&1
      fi
      echo -e "${GREEN}iproute2 安装完成，正在检查端口...${NC}"
      if ss -tuln | grep ":$PORT" &>/dev/null; then
        echo -e "${RED}端口 $PORT 已被占用，请选择其他端口。${NC}"
        continue
      fi
    fi
    break # 端口未被占用，退出循环
  done

  # 创建 nodepassdash 目录
  mkdir -p ~/nodepassdash/logs ~/nodepassdash/db

  # 检查 nodepassdash 容器是否已存在
  if $CONTAINER_CMD inspect nodepassdash &>/dev/null; then
    echo -e "${RED}nodepassdash 容器已存在，退出脚本。${NC}"
    exit 1
  fi

  # 下载最新的镜像并运行容器
  echo -e "${GREEN}正在下载最新的 nodepassdash 镜像...${NC}"
  $CONTAINER_CMD pull ghcr.io/nodepassproject/nodepassdash:latest

  echo -e "${GREEN}正在运行 nodepassdash 容器...${NC}"

  # 构建容器运行命令
  CONTAINER_RUN_CMD="$CONTAINER_CMD run -d \
    --name nodepassdash \
    --network host \
    --restart always \
    -v ~/nodepassdash/logs:/app/logs \
    -v ~/nodepassdash/public:/app/public \
    -v ~/nodepassdash/db:/app/db \
    -e PORT=$PORT"

  # 如果使用自定义证书，添加证书文件挂载和环境变量
  if [ "$TLS_MODE" = "2" ]; then
    CONTAINER_RUN_CMD="$CONTAINER_RUN_CMD \
    -v $CERT_FILE:/app/certs/$(basename $CERT_FILE):ro \
    -v $KEY_FILE:/app/certs/$(basename $KEY_FILE):ro \
    -e TLS_CERT=/app/certs/$(basename $CERT_FILE) \
    -e TLS_KEY=/app/certs/$(basename $KEY_FILE)"
  fi

  # 完成容器运行命令
  CONTAINER_RUN_CMD="$CONTAINER_RUN_CMD \
    ghcr.io/nodepassproject/nodepassdash:latest"

  # 执行容器运行命令
  eval $CONTAINER_RUN_CMD

  # 获取容器日志并提取管理员账户信息
  echo -e "${GREEN}获取面板和管理员账户信息...${NC}"

  # 定义日志检查命令
  LOG_CHECK_COMMAND="$CONTAINER_CMD logs nodepassdash 2>&1"

  # 等待直到出现管理员账户信息，最长不超过 60 秒
  TIMEOUT=60
  ELAPSED=0
  INTERVAL=2

  while [[ $ELAPSED -lt $TIMEOUT ]]; do
    eval "$LOG_CHECK_COMMAND" | grep -q "管理员账户信息" && break
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
  done

  if [[ $ELAPSED -ge $TIMEOUT ]]; then
    echo -e "${RED}${TIMEOUT}秒还没能获取管理员账户信息，请检查容器日志：${NC}"
    eval "$LOG_CHECK_COMMAND"
  else
    echo -e "${GREEN}管理员账户信息已成功获取。${NC}"
  fi

  # 显示面板地址
  if [[ "$INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
    echo -e "${GREEN}面板地址: http://[$INPUT]:$PORT${NC}"
  elif [[ "$INPUT" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
    echo -e "${GREEN}面板地址: http://$INPUT:$PORT${NC}"
  else
    [ "$TLS_MODE" = "2" ] && echo -e "${GREEN}面板地址: https://$INPUT:$PORT${NC}" || echo -e "${GREEN}面板地址: https://$INPUT${NC}"
  fi

  # 展示匹配到的内容
  eval "$LOG_CHECK_COMMAND" | grep -A 5 "管理员账户信息"

  # 脚本当天及累计运行次数统计
  echo -e "${GREEN}脚本当天运行次数: $TODAY，累计运行次数: $TOTAL${NC}"
}

check_os

check_download_cmd

# statistics_of_run-times

# 检查参数
case "$1" in
"update")
  # 如果容器管理工具不存在且未安装，尝试安装
  if ! command -v $CONTAINER_CMD &>/dev/null; then
    install_container_runtime
  fi
  update_nodepassdash
  ;;
"uninstall")
  # 如果容器管理工具不存在且未安装，尝试安装
  if ! command -v $CONTAINER_CMD &>/dev/null; then
    install_container_runtime
  fi
  uninstall_nodepassdash
  ;;
"resetpwd")
  # 如果容器管理工具不存在且未安装，尝试安装
  if ! command -v $CONTAINER_CMD &>/dev/null; then
    install_container_runtime
  fi
  reset_admin_password
  ;;
"install")
  # 如果容器管理工具不存在且未安装，尝试安装
  if ! command -v $CONTAINER_CMD &>/dev/null; then
    install_container_runtime
  fi
  install_nodepassdash
  ;;
"help"|"")
  show_help
  ;;
*)
  echo -e "${RED}错误：未知参数 '$1'${NC}"
  show_help
  exit 1
  ;;
esac
