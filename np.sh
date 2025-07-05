#!/usr/bin/env bash

# 当前脚本版本号
SCRIPT_VERSION='0.0.3'

# 环境变量用于在Debian或Ubuntu操作系统中设置非交互式（noninteractive）安装模式
export DEBIAN_FRONTEND=noninteractive

# Github 反代加速代理
GH_PROXY='https://ghproxy.lvedong.eu.org/'

# 工作目录和临时目录
TEMP_DIR='/tmp/nodepass'
WORK_DIR='/etc/nodepass'

trap "rm -rf $TEMP_DIR >/dev/null 2>&1 ; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

E[0]="\n Language:\n 1. 简体中文\n 2. English"
C[0]="${E[0]}"
E[1]="1.For intranet machines, support creating an instance that tunnels to the NodePass server during installation; 2.Change Github proxy, to better support the domestic environment and only IPv6 machines."
C[1]="1.对于内网机器，支持在安装的时候一并创建穿透到 NodePass 服务端的实例; 2.更换 Github 代理，以更好的支持墙内环境和仅IPv6机器"
E[2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/NodePassProject/npsh/issues]"
C[2]="必须以 root 方式运行脚本，可以输入 sudo -i 后重新下载运行，问题反馈:[https://github.com/NodePassProject/npsh/issues]"
E[3]="Unsupported architecture: \$(uname -m)"
C[3]="不支持的架构: \$(uname -m)"
E[4]="Please choose: "
C[4]="请选择: "
E[5]="The script supports Linux systems only. Feedback: [https://github.com/NodePassProject/npsh/issues]"
C[5]="本脚本只支持 Linux 系统，问题反馈:[https://github.com/NodePassProject/npsh/issues]"
E[6]="NodePass help menu"
C[6]="NodePass 帮助菜单"
E[7]="Install dependence-list:"
C[7]="安装依赖列表:"
E[8]="Failed to install download tool (curl). Please install wget or curl manually."
C[8]="无法安装下载工具（curl）。请手动安装 wget 或 curl。"
E[9]="Failed to download or extract"
C[9]="下载或解压失败"
E[10]="NodePass installed successfully!"
C[10]="NodePass 安装成功！"
E[11]="NodePass has been uninstalled"
C[11]="NodePass 已卸载"
E[12]="Please enter listener IP (The internal machine uses 127.0.0.1):"
C[12]="请输入监听 IP (内网机器使用 127.0.0.1):"
E[13]="Please enter the port (1024-65535, press Enter for random port):"
C[13]="请输入端口 (1024-65535，回车使用随机端口):"
E[14]="Please enter API prefix (lowercase letters, numbers and / only, press Enter for default \"api\"):"
C[14]="请输入 API 前缀 (仅限小写字母、数字和斜杠/，回车使用默认 \"api\"):"
E[15]="Please select TLS mode (press Enter for none TLS encryption):"
C[15]="请选择 TLS 模式 (回车不使用 TLS 加密):"
E[16]="0. None TLS encryption (plain TCP) - Fastest performance, no overhead (default)\n 1. Self-signed certificate (auto-generated) - Fine security with simple setups\n 2. Custom certificate (requires pre-prepared crt and key files) - Highest security with certificate validation"
C[16]="0. 不使用 TLS 加密（明文 TCP） - 最快性能，无开销（默认）\n 1. 自签名证书（自动生成） - 设置简单的良好安全性\n 2. 自定义证书（须预备 crt 和 key 文件） - 具有证书验证的最高安全性"
E[17]="Please enter the correct option"
C[17]="请输入正确的选项"
E[18]="NodePass is already installed, please uninstall it before reinstalling"
C[18]="NodePass 已安装，请先卸载后再重新安装"
E[19]="Downloading NodePass \$LATEST_VERSION ..."
C[19]="开始下载 NodePass \$LATEST_VERSION ..."
E[20]="Failed to get latest version"
C[20]="无法获取最新版本"
E[21]="Running in container environment, skipping service creation and starting process directly"
C[21]="在容器环境中运行，跳过服务创建，直接启动进程"
E[22]="NodePass Script Usage / NodePass 脚本使用方法:\n np - Show menu / 显示菜单\n np -i - Install NodePass / 安装 NodePass\n np -u - Uninstall NodePass / 卸载 NodePass\n np -v - Upgrade NodePass / 升级 NodePass\n np -o - Toggle service status (start/stop) / 切换服务状态 (开启/停止)\n np -k - Change NodePass API key / 更换 NodePass API key\n np -c - Change API intranet penetration server / 更换 API 内网穿透的服务器\n np -s - Show NodePass API info / 显示 NodePass API 信息\n np -h - Show help information / 显示帮助信息"
C[22]="${E[22]}"
E[23]="Please enter the path to your TLS certificate file:"
C[23]="请输入您的 TLS 证书文件路径:"
E[24]="Please enter the path to your TLS private key file:"
C[24]="请输入您的 TLS 私钥文件路径:"
E[25]="Certificate file does not exist:"
C[25]="证书文件不存在:"
E[26]="Private key file does not exist:"
C[26]="私钥文件不存在:"
E[27]="Using custom TLS certificate"
C[27]="使用自定义 TLS 证书"
E[28]="Install"
C[28]="安装"
E[29]="Uninstall"
C[29]="卸载"
E[30]="Upgrade core"
C[30]="升级内核"
E[31]="Exit"
C[31]="退出"
E[32]="not installed"
C[32]="未安装"
E[33]="stopped"
C[33]="已停止"
E[34]="running"
C[34]="运行中"
E[35]="NodePass Installation Information:"
C[35]="NodePass 安装信息:"
E[36]="Port is already in use, please try another one."
C[36]="端口已被占用，请尝试其他端口。"
E[37]="Using random port:"
C[37]="使用随机端口:"
E[38]="Please select: "
C[38]="请选择: "
E[39]="API URL:"
C[39]="API URL:"
E[40]="API KEY:"
C[40]="API KEY:"
E[41]="Invalid port number, please enter a number between 1024 and 65535."
C[41]="无效的端口号，请输入1024到65535之间的数字。"
E[42]="NodePass service has been stopped"
C[42]="NodePass 服务已关闭"
E[43]="NodePass service has been started"
C[43]="NodePass 服务已开启"
E[44]="Unable to get local version"
C[44]="无法获取本地版本"
E[45]="Local version: \$LOCAL_VERSION"
C[45]="本地版本: \$LOCAL_VERSION"
E[46]="Latest version: \$LATEST_VERSION"
C[46]="最新版本: \$LATEST_VERSION"
E[47]="Current version is already the latest, no need to upgrade"
C[47]="当前已是最新版本，不需要升级"
E[48]="Found new version, upgrade? (y/N)"
C[48]="发现新版本，是否升级？(y/N)"
E[49]="Upgrade cancelled"
C[49]="取消升级"
E[50]="Stopping NodePass service..."
C[50]="停止 NodePass 服务..."
E[51]="Starting NodePass service..."
C[51]="启动 NodePass 服务..."
E[52]="NodePass upgrade successful!"
C[52]="NodePass 升级成功！"
E[53]="Failed to start NodePass service, please check logs"
C[53]="NodePass 服务启动失败，请检查日志"
E[54]="Rolled back to previous version"
C[54]="已回滚到之前的版本"
E[55]="Rollback failed, please check manually"
C[55]="回滚失败，请手动检查"
E[56]="Stop API"
C[56]="关闭 API"
E[57]="Create shortcuts successfully: script can be run with [ np ] command, and [ nodepass ] binary is directly executable."
C[57]="创建快捷方式成功: 脚本可通过 [ np ] 命令运行，[ nodepass ] 二进制文件可直接执行!"
E[58]="Start API"
C[58]="开启 API"
E[59]="NodePass is not installed. Configuration file not found"
C[59]="NodePass 未安装，配置文件不存在"
E[60]="NodePass API:"
C[60]="NodePass API:"
E[61]="PREFIX can only contain lowercase letters, numbers, and slashes (/), please re-enter"
C[61]="PREFIX 只能包含小写字母、数字和斜杠(/)，请重新输入"
E[62]="Change KEY"
C[62]="更换 KEY"
E[63]="API KEY changed successfully!"
C[63]="API KEY 更换成功"
E[64]="Failed to change API KEY"
C[64]="API KEY 更换失败"
E[65]="Changing NodePass API KEY..."
C[65]="正在更换 NodePass API KEY..."
E[66]="NodePass Local Core:"
C[66]="NodePass 本地核心:"
E[67]="NodePass Latest Core:"
C[67]="NodePass 最新核心:"
E[68]="Please enter the IP of the public machine (leave blank to not penetrate):"
C[68]="如要把内网的 API 穿透到公网的 NodePass 服务端，请输入公网机器的 IP (留空则不穿透):"
E[69]="Please enter the port of the public machine:"
C[69]="请输入穿透到公网的 NodePass 服务端的端口:"
E[70]="Change API intranet penetration server"
C[70]="更换 API 内网穿透的服务器"
E[71]="Please enter the password (default is no password):"
C[71]="输入密码（默认无密码）:"
E[72]="The service of intranet penetration to remote has been created successfully"
C[72]="内网穿透到远程的服务已创建成功"
E[73]="API intranet penetration server creation failed!"
C[73]="API 内网穿透到远程的服务创建失败!"
E[74]="Not a valid IPv4,IPv6 address or domain name"
C[74]="不是有效的IPv4,IPv6地址或域名"
E[75]="Please enter the IP of the intranet penetration server:"
C[75]="输入新的内网穿透服务端 IP 或域名:"
E[76]="Successfully modified the intranet penetration instance"
C[76]="成功修改内网穿透实例"
E[77]="Failed to modify the intranet penetration instance"
C[77]="修改内网穿透实例失败"

# 自定义字体彩色，read 函数
warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 红色
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; }  # 红色
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 绿色
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 黄色
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

# 显示帮助信息
help() {
  hint " ${E[22]} "
}

# 必须以root运行脚本
check_root() {
  [ "$(id -u)" != 0 ] && error " $(text 2) "
}

# 检查系统要求
check_system() {
  # 只判断是否为 Linux 系统
  [ "$(uname -s)" != "Linux" ] && error " $(text 5) "

  # 检查系统信息
  check_system_info

  # 根据系统类型设置包管理和服务管理命令
  case "$SYSTEM" in
    alpine)
      PACKAGE_INSTALL='apk add'
      PACKAGE_UPDATE='apk update'
      PACKAGE_UNINSTALL='apk del'
      SERVICE_START='rc-service nodepass start'
      SERVICE_STOP='rc-service nodepass stop'
      SERVICE_RESTART='rc-service nodepass restart'
      SERVICE_STATUS='rc-service nodepass status'
      SYSTEMCTL='rc-service'
      SYSTEMCTL_ENABLE='rc-update add nodepass'
      SYSTEMCTL_DISABLE='rc-update del nodepass'
      ;;
    arch)
      PACKAGE_INSTALL='pacman -S --noconfirm'
      PACKAGE_UPDATE='pacman -Syu --noconfirm'
      PACKAGE_UNINSTALL='pacman -R --noconfirm'
      SERVICE_START='systemctl start nodepass'
      SERVICE_STOP='systemctl stop nodepass'
      SERVICE_RESTART='systemctl restart nodepass'
      SERVICE_STATUS='systemctl status nodepass'
      SYSTEMCTL='systemctl'
      SYSTEMCTL_ENABLE='systemctl enable nodepass'
      SYSTEMCTL_DISABLE='systemctl disable nodepass'
      ;;
    debian|ubuntu)
      PACKAGE_INSTALL='apt-get -y install'
      PACKAGE_UPDATE='apt-get update'
      PACKAGE_UNINSTALL='apt-get -y autoremove'
      SERVICE_START='systemctl start nodepass'
      SERVICE_STOP='systemctl stop nodepass'
      SERVICE_RESTART='systemctl restart nodepass'
      SERVICE_STATUS='systemctl status nodepass'
      SYSTEMCTL='systemctl'
      SYSTEMCTL_ENABLE='systemctl enable nodepass'
      SYSTEMCTL_DISABLE='systemctl disable nodepass'
      ;;
    centos|fedora)
      PACKAGE_INSTALL='yum -y install'
      PACKAGE_UPDATE='yum -y update'
      PACKAGE_UNINSTALL='yum -y autoremove'
      SERVICE_START='systemctl start nodepass'
      SERVICE_STOP='systemctl stop nodepass'
      SERVICE_RESTART='systemctl restart nodepass'
      SERVICE_STATUS='systemctl status nodepass'
      SYSTEMCTL='systemctl'
      SYSTEMCTL_ENABLE='systemctl enable nodepass'
      SYSTEMCTL_DISABLE='systemctl disable nodepass'
      ;;
    OpenWRT)
      PACKAGE_INSTALL='opkg install'
      PACKAGE_UPDATE='opkg update'
      PACKAGE_UNINSTALL='opkg remove'
      SERVICE_START='/etc/init.d/nodepass start'
      SERVICE_STOP='/etc/init.d/nodepass stop'
      SERVICE_RESTART='/etc/init.d/nodepass restart'
      SERVICE_STATUS='/etc/init.d/nodepass status'
      SYSTEMCTL='/etc/init.d'
      SYSTEMCTL_ENABLE='/etc/init.d/nodepass enable'
      SYSTEMCTL_DISABLE='/etc/init.d/nodepass disable'
      ;;
    *)
      PACKAGE_INSTALL='apt-get -y install'
      PACKAGE_UPDATE='apt-get update'
      PACKAGE_UNINSTALL='apt-get -y autoremove'
      SERVICE_START='systemctl start nodepass'
      SERVICE_STOP='systemctl stop nodepass'
      SERVICE_RESTART='systemctl restart nodepass'
      SERVICE_STATUS='systemctl status nodepass'
      SYSTEMCTL='systemctl'
      SYSTEMCTL_ENABLE='systemctl enable nodepass'
      SYSTEMCTL_DISABLE='systemctl disable nodepass'
      ;;
  esac

  # 如果在容器环境中，覆盖服务管理方式
  [ "$IN_CONTAINER" = 1 ] && SERVICE_MANAGE="none"
}

# 检查安装状态，状态码: 2 未安装， 1 已安装未运行， 0 运行中
check_install() {
  if [ ! -f "$WORK_DIR/nodepass" ]; then
    return 2
  elif [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      # 过滤掉僵尸进程 <defunct>
      if pgrep -laf "nodepass" | grep -vE "grep|<defunct>" | grep -q "nodepass"; then
        return 0
      else
        return 1
      fi
    else
      # 过滤掉僵尸进程 <defunct>
      if ps -ef | grep -vE "grep|<defunct>" | grep -q "nodepass"; then
        return 0
      else
        return 1
      fi
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ] && ! systemctl is-active nodepass &>/dev/null; then
    return 1
  elif [ "$SERVICE_MANAGE" = "rc-service" ] && ! rc-service nodepass status &>/dev/null; then
    return 1
  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    # OpenWRT 系统检查服务状态
    if [ -f "/var/run/nodepass.pid" ] && kill -0 $(cat "/var/run/nodepass.pid" 2>/dev/null) >/dev/null 2>&1; then
      return 0
    else
      return 1
    fi
  else
    return 0
  fi
}

# 安装系统依赖及定义下载工具
check_dependencies() {
  DEPS_INSTALL=()

  # 检查 wget 和 curl
  if [ -x "$(type -p curl)" ]; then
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  elif [ -x "$(type -p wget)" ]; then
    DOWNLOAD_TOOL="wget"
    DOWNLOAD_CMD="wget -q"
  else
    # 如果都没有，安装 curl
    DEPS_INSTALL+=("curl")
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  fi

  # 检查是否有 ps 或 pkill 命令
  if [ ! -x "$(type -p ps)" ] && [ ! -x "$(type -p pkill)" ]; then
    # 根据不同系统添加对应的包名
    if grep -qi 'alpine' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps")
    elif grep -qi 'debian\|ubuntu' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps")
    elif grep -qi 'centos\|fedora' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps-ng")
    elif grep -qi 'arch' /etc/os-release 2>/dev/null; then
      DEPS_INSTALL+=("procps-ng")
    else
      DEPS_INSTALL+=("procps")
    fi
  fi

  # 检查其他依赖
  local DEPS_CHECK=("tar")
  local PACKAGE_DEPS=("tar")

  for g in "${!DEPS_CHECK[@]}"; do
    [ ! -x "$(type -p ${DEPS_CHECK[g]})" ] && DEPS_INSTALL+=("${PACKAGE_DEPS[g]}")
  done

  if [ "${#DEPS_INSTALL[@]}" -gt 0 ]; then
    info "\n $(text 7) ${DEPS_INSTALL[@]} \n"
    ${PACKAGE_UPDATE} >/dev/null 2>&1
    ${PACKAGE_INSTALL} ${DEPS_INSTALL[@]} >/dev/null 2>&1
  fi
}

# 检查系统信息
check_system_info() {
  # 检查架构
  case "$(uname -m)" in
    x86_64 | amd64 ) ARCH=amd64 ;;
    armv8 | arm64 | aarch64 ) ARCH=arm64 ;;
    armv7l ) ARCH=arm ;;
    s390x ) ARCH=s390x ;;
    * ) error " $(text 3) " ;;
  esac

  # 检查系统
  if [ -f /etc/openwrt_release ]; then
    SYSTEM="OpenWRT"
    SERVICE_MANAGE="init.d"
  elif [ -f /etc/os-release ]; then
    source /etc/os-release
    SYSTEM=$ID
    [[ $SYSTEM = "centos" && $(expr "$VERSION_ID" : '.*\s\([0-9]\{1,\}\)\.*') -ge 7 ]] && SYSTEM=centos
    [[ $SYSTEM = "debian" && $(expr "$VERSION_ID" : '.*\s\([0-9]\{1,\}\)\.*') -ge 10 ]] && SYSTEM=debian
    [[ $SYSTEM = "ubuntu" && $(expr "$VERSION_ID" : '.*\s\([0-9]\{1,\}\)\.*') -ge 16 ]] && SYSTEM=ubuntu
    [[ $SYSTEM = "alpine" && $(expr "$VERSION_ID" : '.*\s\([0-9]\{1,\}\)\.*') -ge 3 ]] && SYSTEM=alpine
  fi

  # 确定服务管理方式
  if [ -z "$SERVICE_MANAGE" ]; then
    if [ -s /etc/systemd/system ]; then
      SERVICE_MANAGE="systemctl"
    elif [ -s /sbin/openrc-run ]; then
      SERVICE_MANAGE="rc-service"
    elif [ -s /etc/init.d ]; then
      SERVICE_MANAGE="init.d"
    else
      SERVICE_MANAGE="none"
    fi
  fi

  # 检查是否在容器环境中
  if [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup; then
    IN_CONTAINER=1
  else
    IN_CONTAINER=0
  fi
}

# 验证IPv4或IPv6地址格式，返回0表示有效，返回1表示无效
validate_ip_address() {
  local IP="$1"
  # IPv4正则表达式
  local IPV4_REGEX='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
  # IPv6正则表达式（简化版）
  local IPV6_REGEX='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'
  # 域名正则表达式（支持常规域名和带点的子域名，不支持特殊字符）
  local DOMAIN_REGEX='^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'

  # localhost 特殊处理
  [ "$IP" = "localhost" ] && IP="127.0.0.1"
  if [[ "$IP" =~ $IPV4_REGEX ]] || [[ "$IP" =~ $IPV6_REGEX ]] || [[ "$IP" =~ $DOMAIN_REGEX ]]; then
    return 0  # 有效IP地址
  else
    warning " $(text 74) "
    return 1  # 无效IP地址
  fi
}

# 检查端口是否可用，返回0表示可用，返回1表示被占用，返回2表示端口不在有效范围内
check_port() {
  local PORT=$1
  local NO_CHECK_USED=$2
  # 检查端口是否为数字且在有效范围内
  if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
    return 2  # 返回2表示端口不在有效范围内
  fi

  if ! grep -q 'no_check_used' <<< "$NO_CHECK_USED"; then
    # 检查端口是否被占用
    # 方法1: 使用 nc 命令
    if [ $(type -p nc) ]; then
      nc -z 127.0.0.1 "$PORT" >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1  # 返回1表示端口被占用
      fi
    # 方法2: 使用 lsof 命令
    elif [ $(type -p lsof) ]; then
      lsof -i:"$PORT" >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1  # 返回1表示端口被占用
      fi
    # 方法3: 使用 netstat 命令
    elif [ $(type -p netstat) ]; then
      netstat -nltup 2>/dev/null | grep -q ":$PORT "
      if [ $? -eq 0 ]; then
        return 1  # 返回1表示端口被占用
      fi
    # 方法4: 使用 ss 命令
    elif [ $(type -p ss) ]; then
      ss -nltup 2>/dev/null | grep -q ":$PORT "
      if [ $? -eq 0 ]; then
        return 1  # 返回1表示端口被占用
      fi
    # 方法5: 尝试使用/dev/tcp检查
    else
      (echo >/dev/tcp/127.0.0.1/"$PORT") >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1  # 返回1表示端口被占用
      fi
    fi

    return 0  # 返回0表示端口可用
  fi
}

# 检测是否需要启用 Github CDN，如能直接连通，则不使用
check_cdn() {
  if [ -n "$GH_PROXY" ]; then
    if [ "$DOWNLOAD_TOOL" = "wget" ]; then
      wget --server-response --quiet --output-document=/dev/null --no-check-certificate --tries=2 --timeout=3 ${GH_PROXY}https://raw.githubusercontent.com/yosebyte/nodepass/refs/heads/main/README.md &>/dev/null || unset GH_PROXY
    else
      curl -sL --connect-timeout 3 --max-time 3 ${GH_PROXY}https://raw.githubusercontent.com/yosebyte/nodepass/refs/heads/main/README.md -o /dev/null &>/dev/null || unset GH_PROXY
    fi
  fi
}

# 选择语言，先判断 ${WORK_DIR}/language 里的语言选择，没有的话再让用户选择，默认英语。处理中文显示的问题
select_language() {
  UTF8_LOCALE=$(locale -a 2>/dev/null | grep -iEm1 "UTF-8|utf8")
  [ -n "$UTF8_LOCALE" ] && export LC_ALL="$UTF8_LOCALE" LANG="$UTF8_LOCALE" LANGUAGE="$UTF8_LOCALE"

  # 优先使用命令行参数指定的语言
  if [ -n "$ARGS_LANGUAGE" ]; then
    case "$ARGS_LANGUAGE" in
      1|zh|CN|cn|chinese|C|c)
        L=C
        ;;
      2|en|EN|english|E|e)
        L=E
        ;;
      *)
        L=C  # 默认使用中文
        ;;
    esac
  # 其次读取保存的配置信息
  elif [ -s ${WORK_DIR}/data ]; then
    source ${WORK_DIR}/data
    L=$LANGUAGE
  # 最后使用交互方式选择
  else
    L=C && hint " $(text 0) \n" && reading " $(text 4) " LANGUAGE_CHOICE
    [ "$LANGUAGE_CHOICE" = 2 ] && L=E
  fi
}

# 查询 NodePass API URL
get_api_url() {
  # 从data文件中获取SERVER_IP
  [ -s "$WORK_DIR/data" ] && source "$WORK_DIR/data"

  # 检查是否已安装
  if [ -s "$WORK_DIR/gob/nodepass.gob" ]; then
    # 在容器环境中优先从data文件获取参数
    if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
      if [ -s "$WORK_DIR/data" ] && grep -q "CMD=" "$WORK_DIR/data" ]; then
        # 从data文件中获取CMD
        local CMD_LINE=$(grep "CMD=" "$WORK_DIR/data" | cut -d= -f2-)
      else
        # 如果data文件中没有CMD，则从进程中获取，过滤掉僵尸进程
        if [ $(type -p pgrep) ]; then
          local CMD_LINE=$(pgrep -af "nodepass" | grep -v "grep\|sed\|<defunct>" | sed -n 's/.*nodepass \(.*\)/\1/p')
        else
          local CMD_LINE=$(ps -ef | grep -v "grep\|sed\|<defunct>" | grep "nodepass" | sed -n 's/.*nodepass \(.*\)/\1/p')
        fi
      fi
    # 根据不同系统类型获取守护文件路径
    elif [ "$SERVICE_MANAGE" = "systemctl" ] && [ -s "/etc/systemd/system/nodepass.service" ]; then
      local CMD_LINE=$(sed -n 's/.*ExecStart=.*\(master.*\)"/\1/p' "/etc/systemd/system/nodepass.service")
    elif [ "$SERVICE_MANAGE" = "rc-service" ] && [ -s "/etc/init.d/nodepass" ]; then
      # 从OpenRC服务文件中提取CMD行
      local CMD_LINE=$(sed -n 's/.*command_args.*\(master.*\)/\1/p' "/etc/init.d/nodepass")
    elif [ "$SERVICE_MANAGE" = "init.d" ] && [ -s "/etc/init.d/nodepass" ]; then
      # 从OpenWRT服务文件中提取CMD行
      local CMD_LINE=$(sed -n 's/^CMD="\([^"]\+\)"/\1/p' "/etc/init.d/nodepass")
    fi

    # 如果找到了CMD行，通过正则提取各个参数
    if [ -n "$CMD_LINE" ]; then
      [[ "$CMD_LINE" =~ master://.*:([0-9]+)/([^?]+)\?log=([^&]+)\&tls=([0-2]) ]]
      PORT="${BASH_REMATCH[1]}"
      PREFIX="${BASH_REMATCH[2]}"
      LOG_LEVEL="${BASH_REMATCH[3]}"
      TLS_MODE="${BASH_REMATCH[4]}"
      grep -qw '0' <<< "$TLS_MODE" && local HTTP_S="http" || local HTTP_S="https"
    fi

    # 优先查找是否有内网穿透的服务器
    unset BASH_REMATCH
    if grep -q '.' <<< "$REMOTE"; then
      [[ $REMOTE =~ (.*@)?(.*):([0-9]+)$ ]]
      local URL_SERVER_PASSWORD="${BASH_REMATCH[1]}"
      local URL_SERVER_IP="${BASH_REMATCH[2]}"
      local URL_SERVER_PORT="${BASH_REMATCH[3]}"
    else
      local URL_SERVER_PORT=$(sed -n 's#.*:\([0-9]\+\)\/.*#\1#p' <<< "$CMD_LINE")
      # 处理IPv6地址格式
      grep -q ':' <<< "$SERVER_IP" && local URL_SERVER_IP="[$SERVER_IP]" || local URL_SERVER_IP="$SERVER_IP"
    fi

    # 构建API URL
    API_URL="${HTTP_S}://${URL_SERVER_PASSWORD}${URL_SERVER_IP}:${URL_SERVER_PORT}/${PREFIX:+${PREFIX%/}/}v1"
    grep -q 'output' <<< "$1" && info " $(text 39) $API_URL "
  else
    warning " $(text 59) "
  fi
}

# 查询 NodePass KEY
get_api_key() {
  # 从nodepass.gob文件中提取KEY
  if [ -s "$WORK_DIR/gob/nodepass.gob" ]; then
    KEY=$(grep -a -o '[0-9a-f]\{32\}' $WORK_DIR/gob/nodepass.gob)
    grep -q 'output' <<< "$1" && info " $(text 40) $KEY"
  else
    warning " $(text 59) "
  fi
}

# 获取随机可用端口，目标范围是 1024-8192，共7168个
get_random_port() {
  local RANDOM_PORT
  while true; do
    RANDOM_PORT=$((RANDOM % 7168 + 1024))
    check_port "$RANDOM_PORT" "check_used" && break
  done
  echo "$RANDOM_PORT"
}

# 获取本地版本
get_local_version() {
  LOCAL_VERSION=$(${WORK_DIR}/nodepass -v 2>/dev/null | sed -n '/Version/s/.*\(v[0-9.]\+\).*/\1/gp')
}

# 获取最新版本
get_latest_version() {
  # 获取最新版本号
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    LATEST_VERSION=$(wget -qO- "${GH_PROXY}https://api.github.com/repos/yosebyte/nodepass/releases/latest" | awk -F '"' '/tag_name/{print $4}')
  else
    LATEST_VERSION=$(curl -sL "${GH_PROXY}https://api.github.com/repos/yosebyte/nodepass/releases/latest" | awk -F '"' '/tag_name/{print $4}')
  fi

  if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
    error " $(text 20) "
  fi

  # 去掉版本号前面的v
  VERSION_NUM=${LATEST_VERSION#v}
}

# 切换 NodePass 服务状态（开启/停止）
on_off() {
  # 检查 NodePass 是否正在运行
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      # 过滤掉僵尸进程
      if pgrep -laf "nodepass" | grep -vE "<defunct>|grep" | grep -q "nodepass"; then
        RUNNING=1
      else
        RUNNING=0
      fi
    else
      # 过滤掉僵尸进程
      if ps -ef | grep -vE "grep|<defunct>" | grep -q "nodepass"; then
        RUNNING=1
      else
        RUNNING=0
      fi
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    if systemctl is-active nodepass >/dev/null 2>&1; then
      RUNNING=1
    else
      RUNNING=0
    fi
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    if rc-service nodepass status | grep -q "started"; then
      RUNNING=1
    else
      RUNNING=0
    fi
  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    if [ -f "/var/run/nodepass.pid" ] && kill -0 $(cat "/var/run/nodepass.pid" 2>/dev/null) >/dev/null 2>&1; then
      RUNNING=1
    else
      RUNNING=0
    fi
  fi

  # 根据当前状态执行相反操作
  if [ "$RUNNING" = 1 ]; then
    stop_nodepass
    info " $(text 42) "
  else
    start_nodepass
    info " $(text 43) "
  fi
}

# 启动 NodePass 服务
start_nodepass() {
  info " $(text 51) "

  # 先清理可能存在的僵尸进程
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    # 查找僵尸进程并尝试清理
    if [ $(type -p pgrep) ]; then
      ZOMBIE_PIDS=$(pgrep -f "nodepass" | xargs ps -p 2>/dev/null | grep "<defunct>" | awk '{print $1}')
      [ -n "$ZOMBIE_PIDS" ] && echo "$ZOMBIE_PIDS" | xargs -r kill -9 >/dev/null 2>&1
    else
      ZOMBIE_PIDS=$(ps -ef | grep -v grep | grep "nodepass" | grep "<defunct>" | awk '{print $2}')
      [ -n "$ZOMBIE_PIDS" ] && echo "$ZOMBIE_PIDS" | xargs -r kill -9 >/dev/null 2>&1
    fi

    # 从 data 文件中获取 CMD 参数
    if [ -s "$WORK_DIR/data" ] && grep -q "CMD=" "$WORK_DIR/data"; then
      source "$WORK_DIR/data"
    else
      # 如果 data 文件中没有 CMD，使用默认值
      CMD="master"
    fi
    nohup $WORK_DIR/nodepass $CMD >/dev/null 2>&1 &
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl start nodepass
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass start
  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    /etc/init.d/nodepass start
  fi
  sleep 2
}

# 停止 NodePass 服务
stop_nodepass() {
  info " $(text 50) "
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    # 查找所有nodepass进程（包括僵尸进程）并终止
    if [ $(type -p pgrep) ]; then
      pgrep -f "nodepass" | xargs -r kill -9 >/dev/null 2>&1
    else
      ps -ef | grep -v grep | grep "nodepass" | awk '{print $2}' | xargs -r kill -9 >/dev/null 2>&1
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl stop nodepass
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass stop
  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    /etc/init.d/nodepass stop
  fi
  sleep 2
}

# 升级 NodePass
upgrade_nodepass() {
  # 获取本地版本
  grep -q '^$' <<< "$LOCAL_VERSION" && get_local_version

  if [ -z "$LOCAL_VERSION" ]; then
    warning " $(text 44) "
    return 1
  fi

  # 获取远程最新版本
  grep -q '^$' <<< "$LATEST_VERSION" && get_latest_version
  info "\n $(text 45) "
  info " $(text 46) "

  # 比较版本
  if [ "$LOCAL_VERSION" = "$LATEST_VERSION" ]; then
    info " $(text 47) "
    return 0
  fi

  # 询问用户是否升级
  reading " $(text 48) " UPGRADE_CHOICE

  if [ "${UPGRADE_CHOICE,,}" != "y" ]; then
    info " $(text 49) "
    return 0
  fi

  # 停止服务
  stop_nodepass

  # 备份旧版本
  cp "$WORK_DIR/nodepass" "$WORK_DIR/nodepass.old"

  # 下载并解压新版本
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    wget "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
  else
    curl -sL "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
  fi

  if [ ! -f "$TEMP_DIR/nodepass" ]; then
    warning " $(text 9) "
    # 恢复旧版本
    mv "$WORK_DIR/nodepass.old" "$WORK_DIR/nodepass"
    info " $(text 54) "
    return 1
  fi

  # 移动到工作目录
  mv "$TEMP_DIR/nodepass" "$WORK_DIR/"
  chmod +x "$WORK_DIR/nodepass"

  # 启动服务
  if start_nodepass; then
    info " $(text 52) "
    # 删除备份
    rm -f "$WORK_DIR/nodepass.old"
  else
    warning " $(text 53) "
    # 回滚
    mv "$WORK_DIR/nodepass.old" "$WORK_DIR/nodepass"
    if start_nodepass; then
      info " $(text 54) "
    else
      error " $(text 55) "
    fi
  fi
}

# 解析命令行参数
parse_args() {
  # 初始化变量
  unset ARGS_SERVER_IP ARGS_PORT ARGS_PREFIX ARGS_TLS_MODE ARGS_LANGUAGE ARGS_CERT_FILE ARGS_KEY_FILE

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --server_ip)
        ARGS_SERVER_IP="$2"
        shift 2
        ;;
      --user_port)
        ARGS_PORT="$2"
        shift 2
        ;;
      --prefix)
        ARGS_PREFIX="$2"
        shift 2
        ;;
      --tls_mode)
        ARGS_TLS_MODE="$2"
        shift 2
        ;;
      --language)
        ARGS_LANGUAGE="$2"
        shift 2
        ;;
      --cert_file)
        ARGS_CERT_FILE="$2"
        shift 2
        ;;
      --key_file)
        ARGS_KEY_FILE="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
}

# 主安装函数
install() {
  # 服务器 IP
  [ -n "$ARGS_SERVER_IP" ] && SERVER_INPUT="$ARGS_SERVER_IP" || reading "\n (1/4) $(text 12) " SERVER_INPUT
  while ! validate_ip_address  "$SERVER_INPUT"; do
    reading "\n (1/4) $(text 12) " SERVER_INPUT
  done
  [[ "$SERVER_INPUT" = "localhost" || "$SERVER_INPUT" = "127.0.0.1" || "$SERVER_INPUT" = "::1" ]] && SERVER_IP="127.0.0.1" || SERVER_IP="$SERVER_INPUT"

  # 端口
  while true; do
    [ -n "$ARGS_PORT" ] && PORT="$ARGS_PORT" || reading "\n (2/4) $(text 13) " PORT
    # 如果用户直接回车，使用随机端口
    if [ -z "$PORT" ]; then
      PORT=$(get_random_port)
      info " $(text 37) $PORT"
      break
    else
      check_port "$PORT" "check_used"
      local PORT_STATUS=$?

      if [ "$PORT_STATUS" = 2 ]; then
        # 端口不在有效范围内
        unset ARGS_PORT PORT
        warning " $(text 41) "
      elif [ "$PORT_STATUS" = 1 ]; then
        # 端口被占用
        unset ARGS_PORT PORT
        warning " $(text 36) "
      else
        # 端口可用
        break
      fi
    fi
  done

  # 如果是内网机器，用于穿透到公网服务端 IP 和 Port
  if grep -q '127.0.0.1' <<< "$SERVER_IP"; then
    [ -z "$ARGS_REMOTE_SERVER_IP" ] && reading "\n $(text 68) " REMOTE_SERVER_INPUT
    until grep -q '^$' <<< "$REMOTE_SERVER_INPUT" || validate_ip_address "$REMOTE_SERVER_INPUT"; do
      reading "\n $(text 68) " REMOTE_SERVER_INPUT
    done

    # 如果输入了公网 IP，则需要进一步输入端口和认证密码
    if grep -q '.' <<< "$REMOTE_SERVER_INPUT"; then
      [ -z "$ARGS_REMOTE_PORT" ] && reading "\n $(text 69) " REMOTE_PORT_INPUT
      while ! check_port "$REMOTE_PORT_INPUT" "no_check_used"; do
        warning " $(text 41) "
        reading "\n $(text 69) " REMOTE_PORT_INPUT
      done

      [ -z "$ARGS_REMOTE_PASSWORD" ] && reading "\n $(text 71) " REMOTE_PASSWORD_INPUT
      grep -q '.' <<< "$REMOTE_PASSWORD_INPUT" && REMOTE_PASSWORD_INPUT+="@"
    fi
  fi

  # 判断远程服务器和 IPv6 地址，构建最终显示的 URL
  if [[ "$REMOTE_SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
    URL_SERVER_IP="[$REMOTE_SERVER_INPUT]"
    URL_SERVER_PORT="$REMOTE_PORT_INPUT"
  elif [[ "$REMOTE_SERVER_INPUT" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ || "$REMOTE_SERVER_INPUT" =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
    URL_SERVER_IP="$REMOTE_SERVER_INPUT"
    URL_SERVER_PORT="$REMOTE_PORT_INPUT"
  elif [[ "$SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
    SERVER_IP="[$SERVER_INPUT]"
    URL_SERVER_IP="$SERVER_IP"
    URL_SERVER_PORT="$PORT"
  elif [[ "$SERVER_INPUT" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
    SERVER_IP="$SERVER_INPUT"
    URL_SERVER_IP="$SERVER_IP"
    URL_SERVER_PORT="$PORT"
  fi

  # API 前缀
  while true; do
    [ -n "$ARGS_PREFIX" ] && PREFIX="$ARGS_PREFIX" || reading "\n (3/4) $(text 14) " PREFIX
    # 如果用户直接回车，使用默认值 api
    [ -z "$PREFIX" ] && PREFIX="api" && break
    # 检查输入是否只包含小写字母、数字和斜杠
    if grep -q '^[a-z0-9/]*$' <<< "$PREFIX"; then
      # 去掉前后空格和前后斜杠
      PREFIX=$(sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s#^/##;s#/$##' <<< "$PREFIX")
      break
    else
      unset ARGS_PREFIX PREFIX
      warning " $(text 61) "
    fi
  done
  [ -z "$PREFIX" ] && PREFIX="api"

  # TLS 模式
  if [ -n "$ARGS_TLS_MODE" ]; then
    TLS_MODE="$ARGS_TLS_MODE"
    if [[ ! "$TLS_MODE" =~ ^[0-2]$ ]]; then
      TLS_MODE=0
    fi
  else
    info "\n (4/4) $(text 15) "
    hint " $(text 16) "
    reading " $(text 38) " TLS_MODE
    if [ -z "$TLS_MODE" ]; then
      TLS_MODE=0
    elif [[ ! "$TLS_MODE" =~ ^[0-2]$ ]]; then
      warning " $(text 17) "
      exit 1
    fi
  fi

  # 如果是自定义证书模式，检查证书文件
  if [ "$TLS_MODE" = "2" ]; then
    # 处理证书文件
    if [ -n "$ARGS_CERT_FILE" ]; then
      if [ ! -f "$ARGS_CERT_FILE" ]; then
        error " $(text 25) $ARGS_CERT_FILE"
      fi
      CERT_FILE="$ARGS_CERT_FILE"
    else
      while true; do
        reading " $(text 23) " CERT_FILE
        if [ -f "$CERT_FILE" ]; then
          break
        else
          warning " $(text 25) $CERT_FILE"
        fi
      done
    fi

    # 处理私钥文件
    if [ -n "$ARGS_KEY_FILE" ]; then
      if [ ! -f "$ARGS_KEY_FILE" ]; then
        error " $(text 26) $ARGS_KEY_FILE"
      fi
      KEY_FILE="$ARGS_KEY_FILE"
    else
      while true; do
        reading " $(text 24) " KEY_FILE
        if [ -f "$KEY_FILE" ]; then
          break
        else
          warning " $(text 26) $KEY_FILE"
        fi
      done
    fi

    CRT_PATH="&crt=${CERT_FILE}&key=${KEY_FILE}"
    info " $(text 27) "
  fi

  grep -qw '0' <<< "$TLS_MODE" && HTTP_S="http" || HTTP_S="https"

  # 获取最新版本
  get_latest_version

  info " $(text 19) "

  # 下载并解压
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    wget "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
  else
    curl -sL "${GH_PROXY}https://github.com/yosebyte/nodepass/releases/download/${LATEST_VERSION}/nodepass_${VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
  fi

  [ ! -f "$TEMP_DIR/nodepass" ] && error " $(text 9) "

  # 构建命令行
  CMD="master://${SERVER_IP}:${PORT}/${PREFIX}?log=info&tls=${TLS_MODE}${CRT_PATH:-}"

  # 移动到工作目录，保存语言选择和服务器IP信息到单个文件
  mkdir -p $WORK_DIR
  echo -e "LANGUAGE=$L\nSERVER_IP=$SERVER_IP" > $WORK_DIR/data
  [[ "$IN_CONTAINER" = 1 || "$SERVICE_MANAGE" = "none" ]] && echo -e "CMD='$CMD'" >> $WORK_DIR/data

  # 移动NodePass可执行文件并设置权限
  mv "$TEMP_DIR/nodepass" "$WORK_DIR/"
  chmod +x "$WORK_DIR/nodepass"

  # 创建服务文件
  create_service

  # 检查服务是否成功启动
  sleep 2  # 等待服务启动

  check_install
  local INSTALL_STATUS=$?

  if [ $INSTALL_STATUS -eq 0 ]; then
    # 创建快捷方式
    create_shortcut
    get_api_key
    info "\n $(text 10) "

    # 如是需要映射到公网的，则执行 api
    if grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT"; then
      # 执行 api
      if [ "$DOWNLOAD_TOOL" = "curl" ]; then
        local CREATE_NEW_INSTANCE_ID=$(curl -sS -X 'POST' \
          "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances" \
          -H 'accept: application/json' \
          -H "X-API-Key: ${KEY}" \
          -H 'Content-Type: application/json' \
          -d "{
            \"url\": \"client://${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${URL_SERVER_PORT}/127.0.0.1:${PORT}?log=error\"
          }" 2>&1 | sed 's/{"id":"\([0-9a-f]\{8\}\)".*/\1/')
      else
        local CREATE_NEW_INSTANCE_ID=$(wget -qO- --method=POST \
          --header="accept: application/json" \
          --header="X-API-Key: ${KEY}" \
          --header="Content-Type: application/json" \
          --body-data="{\"url\": \"client://${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${URL_SERVER_PORT}/127.0.0.1:${PORT}?log=error\"}" \
          "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances" 2>&1 | sed 's/{"id":"\([0-9a-f]\{8\}\)".*/\1/')
      fi

      [ "${#CREATE_NEW_INSTANCE_ID}" = 8 ] && info "\n $(text 72) \n" || warning "\n $(text 73) \n"
      grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT" && echo -e "REMOTE=${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${URL_SERVER_PORT}" >> $WORK_DIR/data
    fi

    # 输出安装信息
    echo "------------------------"
    info " $(text 60) $(text 34) "
    info " $(text 35) "
    info " $(text 39) ${HTTP_S}://${URL_SERVER_IP}:${URL_SERVER_PORT}/${PREFIX}/v1"
    info " $(text 40) ${KEY}"

    echo "------------------------"
  else
    warning " $(text 53) "
  fi

  help
}

create_service() {
  # 如果在容器环境中，不创建服务文件，直接启动进程
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    info " $(text 21) "
    nohup "$WORK_DIR/nodepass" "$CMD" >/dev/null 2>&1 &
    return
  fi

  if [ "$SERVICE_MANAGE" = "systemctl" ]; then
    cat > /etc/systemd/system/nodepass.service << EOF
[Unit]
Description=NodePass Service
Documentation=https://github.com/yosebyte/nodepass
After=network.target

[Service]
Type=simple
ExecStart=$WORK_DIR/nodepass "$CMD"
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable nodepass
    systemctl start nodepass

  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    cat > /etc/init.d/nodepass << EOF
#!/sbin/openrc-run

name="nodepass"
description="NodePass Service"
command="$WORK_DIR/nodepass"
command_args="$CMD"
command_background=true
pidfile="/run/\${RC_SVCNAME}.pid"
output_log="/var/log/\${RC_SVCNAME}.log"
error_log="/var/log/\${RC_SVCNAME}.log"

depend() {
    need net
    after net
}
EOF

    chmod +x /etc/init.d/nodepass
    rc-update add nodepass default
    rc-service nodepass start

  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    cat > /etc/init.d/nodepass << EOF
#!/bin/sh /etc/rc.common

START=99
STOP=10

NAME="NodePass"

PROG="$WORK_DIR/nodepass"
CMD="$CMD"
PID="/var/run/nodepass.pid"

start_service() {
  echo -e "\nStarting NodePass service..."
  \$PROG \$CMD >/dev/null 2>&1 &
  echo \$! > \$PID
}

stop_service() {
  echo "Stopping NodePass service..."
  {
    kill \$(cat \$PID 2>/dev/null)
    rm -f \$PID
  } >/dev/null 2>&1
}

start() {
  start_service
}

stop() {
  stop_service
}

restart() {
  stop
  sleep 2
  start
}

status() {
  if [ -f \$PID ] && kill -0 \$(cat \$PID 2>/dev/null) >/dev/null 2>&1; then
    echo "NodePass is running"
  else
    echo "NodePass is not running"
  fi
}
EOF

    chmod +x /etc/init.d/nodepass
    /etc/init.d/nodepass enable
    /etc/init.d/nodepass start
  fi
}

# 创建快捷方式
create_shortcut() {
  # 根据下载工具构建下载命令
  local DOWNLOAD_COMMAND
  if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    DOWNLOAD_COMMAND="wget --no-check-certificate -qO-"
  else
    DOWNLOAD_COMMAND="curl -ksSL"
  fi

  # 创建快捷方式脚本
  cat > ${WORK_DIR}/np.sh << EOF
#!/usr/bin/env bash

bash <($DOWNLOAD_COMMAND https://run.nodepass.eu/np.sh) \$1
EOF
  chmod +x ${WORK_DIR}/np.sh
  ln -sf ${WORK_DIR}/np.sh /usr/bin/np
  ln -sf ${WORK_DIR}/nodepass /usr/bin/nodepass
  [ -s /usr/bin/np ] && info "\n $(text 57) "
}

# 卸载 NodePass
uninstall() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    # 查找所有nodepass进程（包括僵尸进程）并终止
    if [ $(type -p pgrep) ]; then
      pgrep -f "nodepass" | xargs -r kill -9 >/dev/null 2>&1
    else
      ps -ef | grep -v grep | grep "nodepass" | awk '{print $2}' | xargs -r kill -9 >/dev/null 2>&1
    fi
  elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
    systemctl stop nodepass
    systemctl disable nodepass
    rm -f /etc/systemd/system/nodepass.service
    systemctl daemon-reload
  elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
    rc-service nodepass stop
    rc-update del nodepass
    rm -f /etc/init.d/nodepass
  elif [ "$SERVICE_MANAGE" = "init.d" ]; then
    /etc/init.d/nodepass stop
    /etc/init.d/nodepass disable
    rm -f /etc/init.d/nodepass
  fi

  rm -rf "$WORK_DIR" /usr/bin/{np,nodepass}
  info " $(text 11) "
}

# 更换 NodePass API 内网穿透的服务器
change_api_server() {
  reading "\n $(text 75) " REMOTE_SERVER_INPUT
  until validate_ip_address "$REMOTE_SERVER_INPUT"; do
    reading "\n $(text 75) " REMOTE_SERVER_INPUT
  done

  [[ "$REMOTE_SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]] && REMOTE_SERVER_INPUT="[${REMOTE_SERVER_INPUT}]"

  # 如果输入了公网 IP，则需要进一步输入端口和认证密码
  if grep -q '.' <<< "$REMOTE_SERVER_INPUT"; then
    reading "\n $(text 69) " REMOTE_PORT_INPUT
    while ! check_port "$REMOTE_PORT_INPUT" "no_check_used"; do
      warning " $(text 41) "
      reading "\n $(text 69) " REMOTE_PORT_INPUT
    done

    reading "\n $(text 71) " REMOTE_PASSWORD_INPUT
    grep -q '.' <<< "$REMOTE_PASSWORD_INPUT" && REMOTE_PASSWORD_INPUT+="@"
  fi

  # 执行 api
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    # 修改内网穿透实例内容
    curl -sS -X 'PUT' \
      "http://${SERVER_IP}:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" \
      -H 'accept: application/json' \
      -H "X-API-Key: ${KEY}" \
      -H 'Content-Type: application/json' \
      -d "{
        \"url\": \"client://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${REMOTE_PORT_INPUT}/127.0.0.1:${PORT}?log=error\"
      }" 2>&1
  else
    # 修改内网穿透实例内容
    wget -qO- --method=PUT \
      --header="accept: application/json" \
      --header="X-API-Key: ${KEY}" \
      --header="Content-Type: application/json" \
      --body-data="{\"url\": \"client://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${REMOTE_PORT_INPUT}/127.0.0.1:${PORT}?log=error\"}" \
      "http://${SERVER_IP}:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" 2>&1
  fi

  # 更新 data 文件
  if [ "$?" = 0 ]; then
    sed -i "s/^REMOTE=.*/REMOTE=${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${REMOTE_PORT_INPUT}/" $WORK_DIR/data
    info "\n $(text 76) \n"
  else
    warning "\n $(text 77) \n"
  fi
}

# 更换 NodePass API key
change_api_key() {
  local INSTALL_STATUS=$1
  info " $(text 65) "

  # 如果服务已安装但未运行，先启动服务
  if [ "$INSTALL_STATUS" = 1 ]; then
    start_nodepass
    local NEED_STOP=1
    sleep 2
  fi

  # 获取当前 API URL 和 KEY
  [[ -z "$PORT" || -z "$PREFIX" ]] && get_api_url
  [ -z "$KEY" ] && get_api_key

  # 检查是否获取到了必要信息
  [[ -z "$PORT" || -z "$PREFIX" || -z "$KEY" ]] && error " $(text 64) "

  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    local RESPONSE=$(curl -s -X 'PATCH' \
      "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances/********" \
      -H "accept: application/json" \
      -H "X-API-Key: ${KEY}" \
      -H "Content-Type: application/json" \
      -d '{"action": "restart"}')
  elif [ "$DOWNLOAD_TOOL" = "wget" ]; then
    local RESPONSE=$(wget -qO- --method=PATCH \
      "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances/********" \
      --header='accept: application/json' \
      --header="X-API-Key: ${KEY}" \
      --header='Content-Type: application/json' \
      --body-data='{"action":"restart"}')
  else
    error " $(text 64) "
  fi

  # 从响应中提取新的 KEY
  local NEW_KEY=$(sed 's/.*url":"\([^"]\+\)".*/\1/' <<< "$RESPONSE")

  if [ "${#NEW_KEY}" = 32 ]; then
    # 显示新的 KEY
    info " $(text 63) "

    # 显示 API 信息
    get_api_url output
    info " $(text 40) $NEW_KEY"

    # 如果之前是停止状态，恢复停止状态
    [ "$NEED_STOP" = 1 ] && stop_nodepass

    return 0
  else
    warning " $(text 64) "

    # 如果之前是停止状态，恢复停止状态
    [ "$NEED_STOP" = 1 ] && stop_nodepass

    return 1
  fi

}

# 菜单设置函数 - 根据当前状态设置菜单选项和对应的动作
menu_setting() {
  # 检查安装状态
  INSTALL_STATUS=$1

  # 清空数组
  unset OPTION ACTION

  # 获取在线的最新 NodePass 版本
  get_latest_version

  # 根据安装状态设置菜单选项和动作
  if [ "$INSTALL_STATUS" = 2 ]; then
    # 未安装状态
    NODEPASS_STATUS=$(text 32)
    OPTION[1]="1. $(text 28)"
    OPTION[0]="0. $(text 31)"

    ACTION[1]() { install; exit 0; }
    ACTION[0]() { exit 0; }
  else
    get_api_key
    get_api_url
    get_local_version

    # 已安装状态
    if [ $INSTALL_STATUS -eq 0 ]; then
      NODEPASS_STATUS=$(text 34)
      # 服务已开启
      OPTION[1]="1. $(text 56) (np -o)"
    else
      # 服务已安装但未开启
      NODEPASS_STATUS=$(text 33)
      OPTION[1]="1. $(text 58) (np -o)"
    fi

      OPTION[2]="2. $(text 62) (np -k)"
      OPTION[3]="3. $(text 30) (np -v)"
      OPTION[4]="4. $(text 29) (np -u)"
      grep -q '.' <<< "$REMOTE" && OPTION[5]="5. $(text 70) (np -c)"
      OPTION[0]="0. $(text 31)"

      # 服务未开启时的动作
      ACTION[1]() { on_off $INSTALL_STATUS; exit 0; }
      ACTION[2]() { change_api_key; exit 0; }
      ACTION[3]() { upgrade_nodepass; exit 0; }
      ACTION[4]() { uninstall; exit 0; }
      grep -q '.' <<< "$REMOTE" && ACTION[5]() { change_api_server; exit 0; }
      ACTION[0]() { exit 0; }
  fi
}

# 菜单显示函数 - 显示菜单选项并处理用户输入
menu() {
  # 使用 echo 和转义序列清屏
  echo -e "\033[H\033[2J\033[3J"
  echo "
╭───────────────────────────────────────────╮
│    ░░█▀█░█▀█░░▀█░█▀▀░█▀█░█▀█░█▀▀░█▀▀░░    │
│    ░░█░█░█░█░█▀█░█▀▀░█▀▀░█▀█░▀▀█░▀▀█░░    │
│    ░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀░░    │
├───────────────────────────────────────────┤
│   >Universal TCP/UDP Tunneling Solution   │
│   >https://github.com/yosebyte/nodepass   │
╰───────────────────────────────────────────╯ "

  grep -q '.' <<< "$LOCAL_VERSION" && info " $(text 66) $LOCAL_VERSION "
  grep -q '.' <<< "$LATEST_VERSION" && info " $(text 67) $LATEST_VERSION "
  grep -qEw '0|1' <<< "$INSTALL_STATUS" && info " $(text 60) $NODEPASS_STATUS "
  grep -q '.' <<< "$API_URL" && info " $(text 39) $API_URL"
  grep -q '.' <<< "$KEY" && info " $(text 40) $KEY"

  info " Version: $SCRIPT_VERSION $(text 1) "
  echo "------------------------"

  # 显示菜单选项，但将索引为0的选项放在最后
  for ((b=1;b<=${#OPTION[*]};b++)); do [ "$b" = "${#OPTION[*]}" ] && hint " ${OPTION[0]} " || hint " ${OPTION[b]} "; done

  echo "------------------------"

  # 读取用户选择
  reading " $(text 38) " MENU_CHOICE

  # 处理用户选择，输入必须是数字且在菜单选项范围内
  if grep -qE "^[0-9]+$" <<< "$MENU_CHOICE" && [ "$MENU_CHOICE" -ge 0 ] && [ "$MENU_CHOICE" -lt ${#OPTION[@]} ]; then
    ACTION[$MENU_CHOICE]
  else
    warning " $(text 17) [0-$((${#OPTION[@]}-1))] " && sleep 1 && menu
  fi
}

# 主程序入口
main() {
  # 解析命令行参数
  parse_args "$@"

  # 获取脚本参数
  OPTION="${1,,}"

  # 检查是否为帮助（帮助不需要检查安装状态）
  [ "${1,,}" = "-h" ] && help && exit 0

  # 检查 root 权限
  check_root

  # 检查系统信息
  check_system_info

  # 检查系统
  check_system

  # 检查依赖
  check_dependencies

  # 检查是否需要启用 Github CDN
  check_cdn

  # 检查安装状态
  check_install
  local INSTALL_STATUS=$?

  # 选择语言
  [ "$INSTALL_STATUS" != 2 ] && select_language

  # 根据参数执行相应操作
  case "$1" in
    -i)
      # 安装操作
      if [ "$INSTALL_STATUS" != 2 ]; then
        warning " ${E[18]}\n ${C[18]} "
      else
        grep -q '^$' <<< "$L" && select_language
        install
      fi
      ;;
    -u)
      # 卸载操作
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || uninstall
      ;;
    -v)
      # 升级操作
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || upgrade_nodepass
      ;;
    -o)
      # 切换服务状态
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || on_off $INSTALL_STATUS
      ;;
    -s)
      # 显示API信息
      if [ "$INSTALL_STATUS" = 2 ]; then
        warning " ${E[59]}\n ${C[59]} "
      else
        if [ "$INSTALL_STATUS" = 0 ]; then
          info " $(text 60) $(text 34) "
        else
          info " $(text 60) $(text 33) "
        fi

        get_api_url output
        get_api_key output
      fi
      ;;
    -k)
      # 更换 API key
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || change_api_key $INSTALL_STATUS
      ;;
    -c)
      # 更换 API 服务器
      if [ "$INSTALL_STATUS" != 2 ]; then
        get_api_url
        get_api_key
        change_api_server
      else
        warning " ${E[59]}\n ${C[59]} "
      fi
      ;;
    *)
      # 默认菜单
      grep -q '^$' <<< "$L" && select_language
      menu_setting $INSTALL_STATUS
      menu
      ;;
  esac
}

# 执行主程序
main "$@"