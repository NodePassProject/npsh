#!/usr/bin/env bash

# 当前脚本版本号
SCRIPT_VERSION='0.0.6'


# 环境变量用于在Debian或Ubuntu操作系统中设置非交互式（noninteractive）安装模式
export DEBIAN_FRONTEND=noninteractive

# Github 反代加速代理
GITHUB_PROXY=('https://v6.gh-proxy.org/' 'https://gh-proxy.com/' 'https://hub.glowp.xyz/' 'https://proxy.vvvv.ee/')

# 工作目录和临时目录
TEMP_DIR='/tmp/nodepass'
WORK_DIR='/etc/nodepass'

trap "rm -rf $TEMP_DIR >/dev/null 2>&1 ; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

E[0]="\n Language:\n 1. 简体中文 (Default)\n 2. English"
C[0]="${E[0]}"
E[1]="1. Supports three versions: stable, development, and classic; 2. Supports switching between the three versions (np -t); 3. Added GitHub proxy"
C[1]="1. 支持稳定版、开发版和经典版三个版本; 2. 支持三个版本间切换 (np -t); 3. 增加 Github 代理"
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
E[9]="Failed to download \$APP"
C[9]="下载 \$APP 失败"
E[10]="NodePass installed successfully!"
C[10]="NodePass 安装成功！"
E[11]="NodePass has been uninstalled"
C[11]="NodePass 已卸载"
E[12]="The external network of the current machine is single-stack:\\\n 1. \${SERVER_IPV4_DEFAULT}\${SERVER_IPV6_DEFAULT}\(default\)\\\n 2. Do not listen on the public network, only listen locally"
C[12]="检测到本机的外网是单栈:\\\n 1. \${SERVER_IPV4_DEFAULT}\${SERVER_IPV6_DEFAULT}，监听全栈 \(默认\)\\\n 2. 不对公网监听，只监听本地"
E[13]="Please enter the port (1024-65535, NAT machine must use an open port, press Enter for random port):"
C[13]="请输入端口 (1024-65535，NAT 机器必须使用开放的端口，回车使用随机端口):"
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
E[19]="NodePass \$LATEST\_VERSION and QRencode have been downloaded."
C[19]="已下载 NodePass \$LATEST_VERSION 和 QRencode"
E[20]="Failed to get latest version"
C[20]="无法获取最新版本"
E[21]="Running in container environment, skipping service creation and starting process directly"
C[21]="在容器环境中运行，跳过服务创建，直接启动进程"
E[22]="NodePass Script Usage / NodePass 脚本使用方法:\n np - Show menu / 显示菜单\n np -i - Install NodePass / 安装 NodePass\n np -u - Uninstall NodePass / 卸载 NodePass\n np -v - Upgrade NodePass / 升级 NodePass\n np -t - Switch NodePass version between stable and development / 在稳定版和开发版之间切换 NodePass\n np -o - Toggle service status (start/stop) / 切换服务状态 (开启/停止)\n np -k - Change NodePass API key / 更换 NodePass API key\n np -c - Change intranet penetration server / 更换内网穿透\n np -s - Show NodePass API info / 显示 NodePass API 信息\n np -h - Show help information / 显示帮助信息"
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
E[45]="NodePass Local Core: Stable \$STABLE_LOCAL_VERSION Dev \$DEV_LOCAL_VERSION LTS \$LTS_LOCAL_VERSION"
C[45]="NodePass 本地核心: 稳定版 \$STABLE_LOCAL_VERSION 开发版 \$DEV_LOCAL_VERSION 经典版 \$LTS_LOCAL_VERSION"
E[46]="NodePass Latest Core: Stable \$STABLE_LATEST_VERSION Dev \$DEV_LATEST_VERSION LTS \$LTS_LATEST_VERSION"
C[46]="NodePass 最新核心: 稳定版 \$STABLE_LATEST_VERSION 开发版 \$DEV_LATEST_VERSION 经典版 \$LTS_LATEST_VERSION"
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
C[57]="创建快捷方式成功: 脚本可通过 [ np ] 命令运行，[ nodepass ] 应用可直接执行!"
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
E[66]="Current running version: Development Version"
C[66]="当前运行版本为: 开发版"
E[67]="Current running version: Stable Version"
C[67]="当前运行版本为: 稳定版"
E[68]="Please enter the IP of the public machine (leave blank to not penetrate):"
C[68]="如要把内网的 API 穿透到公网的 NodePass 服务端，请输入公网机器的 IP (留空则不穿透):"
E[69]="Please enter the port of the public machine:"
C[69]="请输入穿透到公网的 NodePass 服务端的端口:"
E[70]="Change intranet penetration server"
C[70]="更换内网穿透"
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
E[78]="The external network of the current machine is dual-stack:\\\n 1. \${SERVER_IPV4_DEFAULT}，listen all stacks \(default\)\\\n 2. \${SERVER_IPV6_DEFAULT}，listen all stacks\\\n 3. Do not listen on the public network, only listen locally"
C[78]="检测到本机的外网是双栈:\\\n 1. \${SERVER_IPV4_DEFAULT}，监听全栈 \(默认\)\\\n 2. \${SERVER_IPV6_DEFAULT}，监听全栈\\\n 3. 不对公网监听，只监听本地"
E[79]="Please select or enter the domain or IP directly:"
C[79]="请选择或者直接输入域名或 IP:"
E[80]="The script runs today: \$TODAY. Total: \$TOTAL"
C[80]="脚本当天运行次数: \$TODAY，累计运行次数: \$TOTAL"
E[81]="Please enter the port on the server that the local machine will connect to for the tunnel (1024–65535):"
C[81]="请输入用于内网穿透中，本机连接到服务端的隧道端口（即服务端监听的端口）（1024–65535）:"
E[82]="Running the service of intranet penetration on the server side:"
C[82]="内网穿透的服务端运行:"
E[83]="Failed to retrieve intranet penetration instance. Instance ID: \${INSTANCE\_ID}"
C[83]="获取内网穿透实例失败，实例ID: \${INSTANCE_ID}"
E[84]="Please select the NodePass core to run. Use [np -t] to switch after installation:\\\n 1. Stable \$STABLE_LATEST_VERSION \(NodePassProject/nodepass\) - Suitable for production environments \(default\)\\\n 2. Development \$DEV_LATEST_VERSION \(NodePassProject/nodepass-core\) - Contains latest features, may be unstable\\\n 3. Classic \$LTS_LATEST_VERSION \(NodePassProject/nodepass-apt\) - Long-term support version"
C[84]="请选择要运行的 NodePass 内核，安装后可使用 [np -t] 切换:\\\n 1. 稳定版 \$STABLE_LATEST_VERSION \(NodePassProject/nodepass\) - 适合生产环境 \(默认\)\\\n 2. 开发版 \$DEV_LATEST_VERSION \(NodePassProject/nodepass-core\) - 包含最新功能，可能不稳定\\\n 3. 经典版 \$LTS_LATEST_VERSION \(NodePassProject/nodepass-apt\) - 长期支持版本"
E[85]="Getting machine IP address..."
C[85]="获取机器 IP 地址中..."
E[86]="Switching NodePass version..."
C[86]="正在切换 NodePass 版本..."
E[87]="Switched successfully"
C[87]="已成功切换"
E[88]="Please select the version to switch to (default is 3):"
C[88]="请选择要切换到的版本 (默认为 3):"
E[89]="NodePass version switch failed"
C[89]="NodePass 版本切换失败"
E[90]="URI:"
C[90]="URI:"
E[91]="No upgrade available for both stable, development and classic versions"
C[91]="稳定版、开发版和经典版均无可用更新"
E[92]="Stable version can be upgraded from \$STABLE_LOCAL_VERSION to \$STABLE_LATEST_VERSION"
C[92]="稳定版可以从 \$STABLE_LOCAL_VERSION 升级到 \$STABLE_LATEST_VERSION"
E[93]="Development version can be upgraded from \$DEV_LOCAL_VERSION to \$DEV_LATEST_VERSION"
C[93]="开发版可以从 \$DEV_LOCAL_VERSION 升级到 \$DEV_LATEST_VERSION"
E[94]="Stable, development or classic version has available updates"
C[94]="稳定版，开发版或经典版有可用更新"
E[95]="Switch core version"
C[95]="切换内核版本"
E[96]="Waiting 5 seconds before starting the service..."
C[96]="正在等待5秒后启动服务..."
E[97]="Current running version:"
C[97]="当前运行版本:"
E[98]="Current running version: Classic Version"
C[98]="当前运行版本为: 经典版"
E[99]="Classic version can be upgraded from \$LTS_LOCAL_VERSION to \$LTS_LATEST_VERSION"
C[99]="经典版可以从 \$LTS_LOCAL_VERSION 升级到 \$LTS_LATEST_VERSION"
E[100]="Switch to stable version (np-stb)"
C[100]="切换到稳定版 (np-stb)"
E[101]="Switch to development version (np-dev)"
C[101]="切换到开发版 (np-dev)"
E[102]="Switch to classic version (np-lts)"
C[102]="切换到经典版 (np-lts)"
E[103]="Cancel switching"
C[103]="取消切换"
E[104]="Please select the version to switch to (default is 3):"
C[104]="请选择要切换到的版本 (默认为 3):"

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
      PACKAGE_INSTALL='apk add --no-cache'
      PACKAGE_UPDATE='apk update -f'
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
  else
    # 根据服务管理方式获取 http 或 https
    if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
      grep -q '^CMD=.*tls=0' ${WORK_DIR}/data && HTTP_S="http" || HTTP_S="https"
    elif [ "$SERVICE_MANAGE" = "systemctl" ]; then
      grep -q '^ExecStart=.*tls=0' /etc/systemd/system/nodepass.service && HTTP_S="http" || HTTP_S="https"
    elif [ "$SERVICE_MANAGE" = "rc-service" ]; then
      grep -q '^command_args=.*tls=0' /etc/init.d/nodepass && HTTP_S="http" || HTTP_S="https"
    elif [ "$SERVICE_MANAGE" = "init.d" ]; then
      grep -q '^PROG=.*tls=0' /etc/init.d/nodepass && HTTP_S="http" || HTTP_S="https"
    fi
  fi

  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
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
    # 如果是 Alpine，先升级 wget
    grep -qi 'alpine' <<< "$SYSTEM" && grep -qi 'busybox' <<< "$(wget 2>&1 | head -n 1)" && apk add --no-cache wget >/dev/null 2>&1
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
    if [ -x "$(type -p systemctl)" ]; then
      SERVICE_MANAGE="systemctl"
    elif [ -x "$(type -p openrc-run)" ]; then
      SERVICE_MANAGE="rc-service"
    elif [[ -x "$(type -p service)" && -d /etc/init.d ]]; then
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
  for PROXY_URL in "${GITHUB_PROXY[@]}"; do
    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
      REMOTE_VERSION=$(curl -ksL --connect-timeout 3 --max-time 3 ${PROXY_URL}https://raw.githubusercontent.com/NodePassProject/npsh/refs/heads/main/README_EN.md 2>/dev/null | sed -nE 's/^-[ ]+(Stable|Development|LTS):/\1:/p')
    else
      REMOTE_VERSION=$(wget -qO- --no-check-certificate --tries=2 --timeout=3 ${PROXY_URL}https://raw.githubusercontent.com/NodePassProject/npsh/refs/heads/main/README_EN.md 2>/dev/null | sed -nE 's/^-[ ]+(Stable|Development|LTS):/\1:/p')
    fi
    grep -q 'Stable' <<< "$REMOTE_VERSION" && GH_PROXY="$PROXY_URL" && break
  done
}

# 脚本当天及累计运行次数统计
statistics_of_run-times() {
  local UPDATE_OR_GET=$1
  local SCRIPT=$2
  if grep -q 'update' <<< "$UPDATE_OR_GET"; then
    { wget --no-check-certificate -qO- --timeout=3 "https://stat.cloudflare.now.cc/api/updateStats?script=${SCRIPT}" > $TEMP_DIR/statistics 2>/dev/null || true; }&
  elif grep -q 'get' <<< "$UPDATE_OR_GET"; then
    [ -s $TEMP_DIR/statistics ] && [[ $(cat $TEMP_DIR/statistics) =~ \"todayCount\":([0-9]+),\"totalCount\":([0-9]+) ]] && local TODAY="${BASH_REMATCH[1]}" && local TOTAL="${BASH_REMATCH[2]}" && rm -f $TEMP_DIR/statistics
    info "\n*******************************************\n\n $(text 80) \n"
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
      [[ "$CMD_LINE" =~ master://.*:([0-9]+)/([^?]+)\?(log=[^&]+&)?tls=([0-2]) ]]
      PORT="${BASH_REMATCH[1]}"
      PREFIX="${BASH_REMATCH[2]}"
      TLS_MODE="${BASH_REMATCH[4]}"
      grep -qw '0' <<< "$TLS_MODE" && local HTTP_S="http" || local HTTP_S="https"
    fi

    # 优先查找是否有内网穿透的服务器
    if grep -q '.' <<< "$REMOTE"; then
      [[ $REMOTE =~ (.*@)?(.*):([0-9]+)$ ]]
      local URL_SERVER_PASSWORD="${BASH_REMATCH[1]}"
      local URL_SERVER_IP="${BASH_REMATCH[2]}"
      URL_SERVER_PORT="${BASH_REMATCH[3]}"
    else
      local URL_SERVER_PORT=$(sed -n 's#.*:\([0-9]\+\)\/.*#\1#p' <<< "$CMD_LINE")
      # 处理IPv6地址格式
      grep -q ':' <<< "$SERVER_IP" && local URL_SERVER_IP="[$SERVER_IP]" || local URL_SERVER_IP="$SERVER_IP"
    fi

    # 构建API URL
    API_URL="${HTTP_S}://${URL_SERVER_IP}:${URL_SERVER_PORT}/${PREFIX:+${PREFIX%/}/}v1"
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

# 查询内网穿透的服务端命令行
get_intranet_penetration_server_cmd() {
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    local CLIENT_CMD=$(curl -ksX 'GET' \
      "$HTTP_S://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" \
      -H 'accept: application/json' \
      -H "X-API-Key: ${KEY}")
  else
    local CLIENT_CMD=$(wget --no-check-certificate -qO- --method=GET \
      --header="accept: application/json" \
      --header="X-API-Key: ${KEY}" \
      "$HTTP_S://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}")
  fi

  # 使用正则表达式匹配client URL，支持带密码和不带密码的情况
  if [[ "$CLIENT_CMD" =~ \"url\":[[:space:]]*\"client://([^\@]*)@?([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|\[[0-9a-fA-F:]+\]):([0-9]+)/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+\" ]]; then
    grep -q '.' <<< "${BASH_REMATCH[1]}" && local REMOTE_PASSWORD_INPUT="${BASH_REMATCH[1]}@"
    local REMOTE_SERVER_INPUT="${BASH_REMATCH[2]}"
    local TUNNEL_PORT_INPUT="${BASH_REMATCH[3]}"
    SERVER_CMD="server://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${TUNNEL_PORT_INPUT}/:${URL_SERVER_PORT}"
    grep -q 'output' <<< "$1" && info " $(text 82) $SERVER_CMD"
  else
    warning " $(text 83) "
  fi
}

# 生成 URI
get_uri() {
  grep -q '^$' <<< "$API_URL" && get_api_url
  grep -q '^$' <<< "$KEY" && get_api_key

  URI="np://master?url=$(echo -n "$API_URL" | base64 -w0)&key=$(echo -n "$KEY" | base64 -w0)"

  grep -q 'output' <<< "$1" && grep -q '.' <<< "$URI" && info " $(text 90) $URI" && ${WORK_DIR}/qrencode "$URI"
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
  if grep -qw 'all' <<< "$1"; then
    DEV_LOCAL_VERSION=$(${WORK_DIR}/np-dev 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*')
    STABLE_LOCAL_VERSION=$(${WORK_DIR}/np-stb 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*')
    LTS_LOCAL_VERSION=$(${WORK_DIR}/np-lts 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*')
  fi
  local GET_SYMLINK_TARGET=$(readlink ${WORK_DIR}/nodepass 2>/dev/null)
  if grep -q 'np-dev' <<< "$GET_SYMLINK_TARGET"; then
    VERSION_TYPE_TEXT=$(text 66)
  elif grep -q 'np-stb' <<< "$GET_SYMLINK_TARGET"; then
    VERSION_TYPE_TEXT=$(text 67)
  elif grep -q 'np-lts' <<< "$GET_SYMLINK_TARGET"; then
    VERSION_TYPE_TEXT=$(text 98)
  fi
  RUNNING_LOCAL_VERSION=$(${WORK_DIR}/nodepass 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*')
}

# 获取最新版本
get_latest_version() {
  STABLE_LATEST_VERSION=$(awk -F '[ ]' '/Stable/{print $NF}' <<< "$REMOTE_VERSION")
  DEV_LATEST_VERSION=$(awk -F '[ ]' '/Development/{print $NF}' <<< "$REMOTE_VERSION")
  LTS_LATEST_VERSION=$(awk -F '[ ]' '/LTS/{print $NF}' <<< "$REMOTE_VERSION")

  [[ -z "$STABLE_LATEST_VERSION" || -z "$DEV_LATEST_VERSION" || -z "$LTS_LATEST_VERSION" ]] && error " $(text 20) "

  # 去掉版本号前面的v
  STABLE_VERSION_NUM=${STABLE_LATEST_VERSION#v}
  DEV_VERSION_NUM=${DEV_LATEST_VERSION#v}
  LTS_VERSION_NUM=${LTS_LATEST_VERSION#v}
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

# 处理旧应用名
compatibility_old_binary() {
  # 检查旧文件是否存在
  [ -f "$WORK_DIR/stable-nodepass" ] && mv "$WORK_DIR/stable-nodepass" "$WORK_DIR/np-stb"
  [ -f "$WORK_DIR/dev-nodepass" ] && mv "$WORK_DIR/dev-nodepass" "$WORK_DIR/np-dev"

  # 检查软链接指向的文件
  if [ -L "$WORK_DIR/nodepass" ]; then
    local CURRENT_SYMLINK=$(readlink "$WORK_DIR/nodepass")
    # 根据软链接指向的旧文件名更新为新文件名
    if [[ "$CURRENT_SYMLINK" == *"stable-nodepass"* ]]; then
      ln -sf "$WORK_DIR/np-stb" "$WORK_DIR/nodepass"
    elif [[ "$CURRENT_SYMLINK" == *"dev-nodepass"* ]]; then
      ln -sf "$WORK_DIR/np-dev" "$WORK_DIR/nodepass"
    fi
  fi

  # 如果缺少LTS版本，下载它
  if [ -d $WORK_DIR ] && ! [ -f "$WORK_DIR/np-lts" ]; then
    # 获取LTS版本信息
    get_latest_version

    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
    else
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
    fi

    [ -s "$TEMP_DIR/nodepass-apt" ] && mv "$TEMP_DIR/nodepass-apt" "$WORK_DIR/np-lts" && chmod +x "$WORK_DIR/np-lts"
    get_local_version
  fi
}

# 升级 NodePass
upgrade_nodepass() {
  # 获取本地版本
  get_local_version all

  # 获取远程最新版本
  get_latest_version

  info "\n $(text 45) "
  info " $(text 46) "

  # 检查是否有可用更新
  local HAS_UPGRADE=0
  local HAS_STABLE_UPGRADE=0
  local HAS_DEV_UPGRADE=0
  local HAS_LTS_UPGRADE=0

  # 显示可切换的版本选项
  local OPTION_INDEX=1
  local AVAILABLE_INDICES=()

  local UPGRADE_INFO=""

  # 检查稳定版是否有更新
  if [ -n "$STABLE_LOCAL_VERSION" ] && [ -n "$STABLE_LATEST_VERSION" ] && [ "$STABLE_LOCAL_VERSION" != "$STABLE_LATEST_VERSION" ]; then
    HAS_UPGRADE=1
    HAS_STABLE_UPGRADE=1
    UPGRADE_INFO+="\n $(text 92) "
  fi

  # 检查开发版是否有更新
  if [ -n "$DEV_LOCAL_VERSION" ] && [ -n "$DEV_LATEST_VERSION" ] && [ "$DEV_LOCAL_VERSION" != "$DEV_LATEST_VERSION" ]; then
    HAS_UPGRADE=1
    HAS_DEV_UPGRADE=1
    UPGRADE_INFO+="\n $(text 93) "
  fi

  # 检查经典版(LTS)是否有更新
  if [ -n "$LTS_LOCAL_VERSION" ] && [ -n "$LTS_LATEST_VERSION" ] && [ "$LTS_LOCAL_VERSION" != "$LTS_LATEST_VERSION" ]; then
    HAS_UPGRADE=1
    HAS_LTS_UPGRADE=1
    UPGRADE_INFO+="\n $(text 99) "
  fi

  # 如果有更新，提示用户
  if [ "$HAS_UPGRADE" = 1 ]; then
    info " $(text 94) "
    echo -e "$UPGRADE_INFO"
    reading "\n $(text 48) " UPGRADE_CHOICE

    if [ "${UPGRADE_CHOICE,,}" != "y" ]; then
      info " $(text 49) "
      exit 0
    fi
  else
    info " $(text 91) "
    exit 0
  fi

  # 确定是否需要重启服务
  local NEED_RESTART=0

  # 如果当前运行的是开发版，且开发版有更新，则需要重启
  if [ "$VERSION_TYPE_TEXT" = "$(text 67)" ] && [ "$HAS_STABLE_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  # 如果当前运行的是稳定版，且稳定版有更新，则需要重启
  elif [ "$VERSION_TYPE_TEXT" = "$(text 66)" ] && [ "$HAS_DEV_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  # 如果当前运行的是经典版，且经典版有更新，则需要重启
  elif [ "$VERSION_TYPE_TEXT" = "$(text 98)" ] && [ "$HAS_LTS_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  # 如果三个版本都有更新，则需要重启
  elif [ "$HAS_STABLE_UPGRADE" = 1 ] && [ "$HAS_DEV_UPGRADE" = 1 ] && [ "$HAS_LTS_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  fi

  # 如果需要重启服务，则停止服务
  [ "$NEED_RESTART" = 1 ] && stop_nodepass

  # 备份旧版本
  [ "$HAS_STABLE_UPGRADE" = 1 ] && cp "$WORK_DIR/np-stb" "$WORK_DIR/np-stb.old" 2>/dev/null
  [ "$HAS_DEV_UPGRADE" = 1 ] && cp "$WORK_DIR/np-dev" "$WORK_DIR/np-dev.old" 2>/dev/null
  [ "$HAS_LTS_UPGRADE" = 1 ] && cp "$WORK_DIR/np-lts" "$WORK_DIR/np-lts.old" 2>/dev/null

  # 下载并解压新版本
  local DOWNLOAD_SUCCESS=1

  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    # 下载稳定版
    if [ "$HAS_STABLE_UPGRADE" = 1 ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass" ]; then
        mv "$TEMP_DIR/nodepass" "$WORK_DIR/np-stb"
        chmod +x "$WORK_DIR/np-stb"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    # 下载开发版
    if [ "$HAS_DEV_UPGRADE" = 1 ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-core" ]; then
        mv "$TEMP_DIR/nodepass-core" "$WORK_DIR/np-dev"
        chmod +x "$WORK_DIR/np-dev"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    # 下载经典版(LTS)
    if [ "$HAS_LTS_UPGRADE" = 1 ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-apt" ]; then
        mv "$TEMP_DIR/nodepass-apt" "$WORK_DIR/np-lts"
        chmod +x "$WORK_DIR/np-lts"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi
  else
    # 下载稳定版
    if [ "$HAS_STABLE_UPGRADE" = 1 ]; then
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass" ]; then
        mv "$TEMP_DIR/nodepass" "$WORK_DIR/np-stb"
        chmod +x "$WORK_DIR/np-stb"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    # 下载开发版
    if [ "$HAS_DEV_UPGRADE" = 1 ]; then
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-core" ]; then
        mv "$TEMP_DIR/nodepass-core" "$WORK_DIR/np-dev"
        chmod +x "$WORK_DIR/np-dev"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    # 下载经典版(LTS)
    if [ "$HAS_LTS_UPGRADE" = 1 ]; then
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-apt" ]; then
        mv "$TEMP_DIR/nodepass-apt" "$WORK_DIR/np-lts"
        chmod +x "$WORK_DIR/np-lts"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi
  fi

  if [ "$DOWNLOAD_SUCCESS" = 0 ]; then
    warning " $(text 9) "
    # 恢复旧版本
    [ -s $WORK_DIR/np-stb.old ] && mv "$WORK_DIR/np-stb.old" "$WORK_DIR/np-stb" 2>/dev/null
    [ -s $WORK_DIR/np-dev.old ] && mv "$WORK_DIR/np-dev.old" "$WORK_DIR/np-dev" 2>/dev/null
    [ -s $WORK_DIR/np-lts.old ] && mv "$WORK_DIR/np-lts.old" "$WORK_DIR/np-lts" 2>/dev/null

    # 如果之前停止了服务，则重新启动
    [ "$NEED_RESTART" = 1 ] && info " $(text 54) " && start_nodepass
    return 1
  fi

  # 如果需要重启服务，则启动服务
  if [ "$NEED_RESTART" = 1 ]; then
    # 添加5秒延迟
    info " $(text 96) " && sleep 5
    if start_nodepass; then
      info " $(text 52) "
      # 删除备份
      rm -f "$WORK_DIR/np-stb.old" "$WORK_DIR/np-dev.old" "$WORK_DIR/np-lts.old"
    else
      warning " $(text 53) "
      # 回滚
      mv "$WORK_DIR/np-stb.old" "$WORK_DIR/np-stb" 2>/dev/null
      mv "$WORK_DIR/np-dev.old" "$WORK_DIR/np-dev" 2>/dev/null
      mv "$WORK_DIR/np-lts.old" "$WORK_DIR/np-lts" 2>/dev/null
      if start_nodepass; then
        info " $(text 54) "
      else
        error " $(text 55) "
      fi
    fi
  else
    info " $(text 52) "
    # 删除备份
    rm -f "$WORK_DIR/np-stb.old" "$WORK_DIR/np-dev.old" "$WORK_DIR/np-lts.old"
  fi
}

# 切换 NodePass 版本 (稳定版 <-> 开发版 <-> 经典版)
switch_nodepass_version() {
  # 检查是否已安装
  if [ ! -f "$WORK_DIR/np-stb" ] && [ ! -f "$WORK_DIR/np-dev" ] && [ ! -f "$WORK_DIR/np-lts" ]; then
    warning " $(text 59) "
    return 1
  fi

  info " $(text 86) "

  # 获取当前使用的版本和版本号
  get_local_version all

  # 备份当前版本链接
  [ -L "$WORK_DIR/nodepass" ] && cp -f "$WORK_DIR/nodepass" "$WORK_DIR/nodepass.bak"

  # 显示当前运行版本
  info "\n $(text 97) $VERSION_TYPE_TEXT $RUNNING_LOCAL_VERSION"

  # 根据当前版本，显示可切换的其他版本
  # 定义版本信息数组
  VERSION_TYPE_TEXT_ARRAY=("$(text 67)" "$(text 66)" "$(text 98)")
  VERSION_NAMES=("stable" "development" "lts")
  VERSION_FILES=("$WORK_DIR/np-stb" "$WORK_DIR/np-dev" "$WORK_DIR/np-lts")
  VERSION_TEXTS=("$(text 67)" "$(text 66)" "$(text 98)")
  VERSION_LOCAL_VERSIONS=("$STABLE_LOCAL_VERSION" "$DEV_LOCAL_VERSION" "$LTS_LOCAL_VERSION")
  VERSION_DISPLAY_TEXTS=("$(text 100)" "$(text 101)" "$(text 102)")

  # 确定当前版本索引
  for i in "${!VERSION_TYPE_TEXT_ARRAY[@]}"; do
    [ "$VERSION_TYPE_TEXT" = "${VERSION_TYPE_TEXT_ARRAY[$i]}" ] && CURRENT_INDEX=$i && break
  done

  # 显示可切换的版本选项
  local OPTION_INDEX=1
  local AVAILABLE_INDICES=()

  for i in "${!VERSION_NAMES[@]}"; do
    if [ "$i" != "$CURRENT_INDEX" ]; then
      hint " $OPTION_INDEX. ${VERSION_DISPLAY_TEXTS[$i]} ${VERSION_LOCAL_VERSIONS[$i]}"
      AVAILABLE_INDICES+=($i)
      ((OPTION_INDEX++))
    fi
  done

  hint " 3. $(text 103)"
  reading "\n $(text 104) " SWITCH_CHOICE
  SWITCH_CHOICE=${SWITCH_CHOICE:-3}

  case "$SWITCH_CHOICE" in
    1)
      TARGET_INDEX=${AVAILABLE_INDICES[0]}
      TARGET_VERSION=${VERSION_NAMES[$TARGET_INDEX]}
      TARGET_FILE=${VERSION_FILES[$TARGET_INDEX]}
      TARGET_TEXT=${VERSION_TEXTS[$TARGET_INDEX]}
      ;;
    2)
      TARGET_INDEX=${AVAILABLE_INDICES[1]}
      TARGET_VERSION=${VERSION_NAMES[$TARGET_INDEX]}
      TARGET_FILE=${VERSION_FILES[$TARGET_INDEX]}
      TARGET_TEXT=${VERSION_TEXTS[$TARGET_INDEX]}
      ;;
    *)
      info " $(text 103)"
      return 0
      ;;
  esac

  # 停止服务
  stop_nodepass

  # 切换版本
  ln -sf "$TARGET_FILE" "$WORK_DIR/nodepass"

  # 添加5秒延迟
  info " $(text 96) " && sleep 5

  # 启动服务
  if start_nodepass; then
    get_local_version running
    info " $(text 87)\n $TARGET_TEXT $RUNNING_LOCAL_VERSION"
  else
    warning " $(text 89) "
    # 尝试回滚到原来的版本
    [ -f "$WORK_DIR/nodepass.bak" ] && cp -f "$WORK_DIR/nodepass.bak" "$WORK_DIR/nodepass" && start_nodepass
  fi

  # 清理备份文件
  rm -f "$WORK_DIR/nodepass.bak"
}

# 解析命令行参数
parse_args() {
  # 初始化变量
  unset ARGS_SERVER_IP ARGS_PORT ARGS_PREFIX ARGS_TLS_MODE ARGS_LANGUAGE ARGS_CERT_FILE ARGS_KEY_FILE ARGS_VERSION

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
      --version)
        ARGS_VERSION="$2"
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
  # 根据用户输入的 IP 地址，选择对应的 IP 地址
  handle_ip_input() {
    local IP="$1"

    unset SERVER_INPUT

    # 去掉用户输入 IPv6 时的方括号  # 去掉用户输入 IPv6 时的方括号
    IP=$(sed 's/[][]//g' <<< "$IP")

    # 如果输入的是 localhost 或 127.0.0.1 或 ::1，则设置为 127.0.0.1
    if [[ "$IP" = "localhost" || "$IP" = "127.0.0.1" || "$IP" = "::1" ]]; then
      SERVER_INPUT="127.0.0.1"
    else
      # 如果获取到 IPv4 和 IPv6，则提示用户选择
      if grep -q '.' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '.' <<< "${SERVER_IPV6_DEFAULT}"; then
        case "$IP" in
          1|"") SERVER_INPUT="${SERVER_IPV4_DEFAULT}" ;;
          2) SERVER_INPUT="${SERVER_IPV6_DEFAULT}" ;;
          3) SERVER_INPUT="127.0.0.1" ;;
          *) SERVER_INPUT="$IP" ;;
        esac
      # 如果获取到 IPv4 或 IPv6，则设置为对应的 IP
      elif ( grep -q '.' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '^$' <<< "${SERVER_IPV6_DEFAULT}" ) || ( grep -q '^$' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '.' <<< "${SERVER_IPV6_DEFAULT}" ); then
        case "$IP" in
          1|"") SERVER_INPUT="${SERVER_IPV4_DEFAULT}${SERVER_IPV6_DEFAULT}" ;;
          2) SERVER_INPUT="127.0.0.1" ;;
          *) SERVER_INPUT="$IP" ;;
        esac

      # 如果获取不到 IPv4 和 IPv6，则设置为输入的 IP
      else
        SERVER_INPUT="$IP"
      fi
    fi
  }

  # 后台下载 NodePass 和 qrencode（60秒超时，重试2次）
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    { curl --connect-timeout 60 --max-time 60 --retry 2 -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"; } &
    { curl --connect-timeout 60 --max-time 60 --retry 2 -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"; } &
    { curl --connect-timeout 60 --max-time 60 --retry 2 -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"; } &
    { curl --connect-timeout 60 --max-time 60 --retry 2 -o "$TEMP_DIR/qrencode" "${GH_PROXY}https://github.com/fscarmen/client_template/raw/main/qrencode-go/qrencode-go-linux-$ARCH" >/dev/null 2>&1 && chmod +x "$TEMP_DIR/qrencode" >/dev/null 2>&1; } &
  else
    { wget --timeout=60 --tries=2 "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"; } &
    { wget --timeout=60 --tries=2 "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"; } &
    { wget --timeout=60 --tries=2 "${GH_PROXY}https://github.com/NodePassProject/nodepass-apt/releases/download/${LTS_LATEST_VERSION}/nodepass-apt_${LTS_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"; } &
    { wget --no-check-certificate --timeout=60 --tries=2 --continue -qO "$TEMP_DIR/qrencode" "${GH_PROXY}https://github.com/fscarmen/client_template/raw/main/qrencode-go/qrencode-go-linux-$ARCH" >/dev/null 2>&1 && chmod +x "$TEMP_DIR/qrencode" >/dev/null 2>&1; } &
  fi
  rm -f $TEMP_DIR/{README.md,README_zh.md,LICENSE}

  # 服务器 IP
  if [ -n "$ARGS_SERVER_IP" ]; then
    SERVER_INPUT="$ARGS_SERVER_IP"
  else
    hint "\n $(text 85) "
    if [ $(type -p ip) ]; then
      local DEFAULT_LOCAL_INTERFACE4=$(ip -4 route show default | awk '/default/ {for (i=0; i<NF; i++) if ($i=="dev") {print $(i+1); exit}}')
      local DEFAULT_LOCAL_INTERFACE6=$(ip -6 route show default | awk '/default/ {for (i=0; i<NF; i++) if ($i=="dev") {print $(i+1); exit}}')

      if [ -n ""${DEFAULT_LOCAL_INTERFACE4}${DEFAULT_LOCAL_INTERFACE6}"" ]; then
        grep -q '.' <<< "$DEFAULT_LOCAL_INTERFACE4" && local DEFAULT_LOCAL_IP4=$(ip -4 addr show $DEFAULT_LOCAL_INTERFACE4 | sed -n 's#.*inet \([^/]\+\)/[0-9]\+.*global.*#\1#gp')
        grep -q '.' <<< "$DEFAULT_LOCAL_INTERFACE6" && local DEFAULT_LOCAL_IP6=$(ip -6 addr show $DEFAULT_LOCAL_INTERFACE6 | sed -n 's#.*inet6 \([^/]\+\)/[0-9]\+.*global.*#\1#gp')

        if [ "$DOWNLOAD_TOOL" = "curl" ]; then
          grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local BIND_ADDRESS4="--interface $DEFAULT_LOCAL_INTERFACE4"
          grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local BIND_ADDRESS6="--interface $DEFAULT_LOCAL_INTERFACE6"
        else
          grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local BIND_ADDRESS4="--bind-address=$DEFAULT_LOCAL_IP4"
          grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local BIND_ADDRESS6="--bind-address=$DEFAULT_LOCAL_IP6"
        fi
      fi
    fi

    # 尝试从 IP api 获取服务器 IP
    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
      grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local SERVER_IPV4_DEFAULT=$(curl -s $BIND_ADDRESS4 --retry 2 --max-time 3 http://api-ipv4.ip.sb || curl -s $BIND_ADDRESS4 --retry 2 --max-time 3 http://ipv4.icanhazip.com)
      grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local SERVER_IPV6_DEFAULT=$(curl -s $BIND_ADDRESS6 --retry 2 --max-time 3 http://api-ipv6.ip.sb || curl -s $BIND_ADDRESS6 --retry 2 --max-time 3 http://ipv6.icanhazip.com)
    else
      grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local SERVER_IPV4_DEFAULT=$(wget -qO- $BIND_ADDRESS4 --tries=2 --timeout=3 http://api-ipv4.ip.sb || wget -qO- $BIND_ADDRESS4 --tries=2 --timeout=3 http://ipv4.icanhazip.com)
      grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local SERVER_IPV6_DEFAULT=$(wget -qO- $BIND_ADDRESS6 --tries=2 --timeout=3 http://api-ipv6.ip.sb || wget -qO- $BIND_ADDRESS6 --tries=2 --timeout=3 http://ipv6.icanhazip.com)
    fi
  fi

  # 询问用户选择版本类型
  case "$VERSION_TYPE_CHOICE" in
    dev ) VERSION_TYPE_CHOICE="2" ;;
    lts ) VERSION_TYPE_CHOICE="3" ;;
    stable ) VERSION_TYPE_CHOICE="1" ;;
  esac

  grep -q '^$' <<< "$VERSION_TYPE_CHOICE" && hint "\n (1/5) $(text 84) \n" && reading " $(text 4) " VERSION_TYPE_CHOICE

  # 如果获取到 IPv4 和 IPv6，则提示用户选择
  if grep -q '.' <<< "$SERVER_IPV4_DEFAULT" && grep -q '.' <<< "$SERVER_IPV6_DEFAULT"; then
    hint "\n (2/5) $(text 78) " && reading "\n $(text 79) " SERVER_INPUT
    handle_ip_input "$SERVER_INPUT"
  else
    hint "\n (2/5) $(text 12) " && reading "\n $(text 79) " SERVER_INPUT
    handle_ip_input "$SERVER_INPUT"
  fi

  while ! validate_ip_address  "$SERVER_INPUT"; do
    if grep -q '.' <<< "$SERVER_IPV4_DEFAULT" && grep -q '.' <<< "$SERVER_IPV6_DEFAULT"; then
      hint "\n (2/5) $(text 78) " && reading "\n $(text 79) " SERVER_INPUT
      handle_ip_input "$SERVER_INPUT"
    else
      hint "\n (2/5) $(text 12) " && reading "\n $(text 79) " SERVER_INPUT
      handle_ip_input "$SERVER_INPUT"
    fi
  done

  # 端口
  while true; do
    [ -n "$ARGS_PORT" ] && PORT="$ARGS_PORT" || reading "\n (3/5) $(text 13) " PORT
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
  if grep -q '127.0.0.1' <<< "$SERVER_INPUT"; then
    [ -z "$ARGS_REMOTE_SERVER_IP" ] && reading "\n $(text 68) " REMOTE_SERVER_INPUT
    REMOTE_SERVER_INPUT=$(sed 's/[][]//g' <<< "$REMOTE_SERVER_INPUT")
    REMOTE_SERVER_INPUT=${REMOTE_SERVER_INPUT:-"127.0.0.1"}
    until validate_ip_address "$REMOTE_SERVER_INPUT"; do
      reading "\n $(text 68) " REMOTE_SERVER_INPUT
      REMOTE_SERVER_INPUT=$(sed 's/[][]//g' <<< "$REMOTE_SERVER_INPUT")
    done

    # 如果输入了公网 IP，则需要进一步输入端口和认证密码
    if grep -q '.' <<< "$REMOTE_SERVER_INPUT" && ! grep -q '127\.0\.0\.1' <<< "$REMOTE_SERVER_INPUT"; then
      [ -z "$ARGS_TUNNEL_PORT" ] && reading "\n $(text 81) " TUNNEL_PORT_INPUT
      while ! check_port "$TUNNEL_PORT_INPUT" "check_used"; do
        warning " $(text 41) "
        reading "\n $(text 81) " TUNNEL_PORT_INPUT
      done

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
    CMD_SERVER_IP="127.0.0.1"
    URL_SERVER_IP="[$REMOTE_SERVER_INPUT]"
    grep -q '.' <<< "$REMOTE_PORT_INPUT" && URL_SERVER_PORT="$REMOTE_PORT_INPUT" || URL_SERVER_PORT="$PORT"
  elif [[ "$REMOTE_SERVER_INPUT" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ || "$REMOTE_SERVER_INPUT" =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
    CMD_SERVER_IP="127.0.0.1"
    URL_SERVER_IP="$REMOTE_SERVER_INPUT"
    grep -q '.' <<< "$REMOTE_PORT_INPUT" && URL_SERVER_PORT="$REMOTE_PORT_INPUT" || URL_SERVER_PORT="$PORT"
  elif [[ "$SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]]; then
    grep -q '127.0.0.1' <<< "$SERVER_IP" && CMD_SERVER_IP="127.0.0.1" || CMD_SERVER_IP=""
    SERVER_IP="$SERVER_INPUT"
    URL_SERVER_IP="[$SERVER_IP]"
    URL_SERVER_PORT="$PORT"
  elif [[ "$SERVER_INPUT" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ || "$SERVER_INPUT" =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
    grep -q '127.0.0.1' <<< "$SERVER_IP" && CMD_SERVER_IP="127.0.0.1" || CMD_SERVER_IP=""
    SERVER_IP="$SERVER_INPUT"
    URL_SERVER_IP="$SERVER_IP"
    URL_SERVER_PORT="$PORT"
  fi

  # API 前缀
  while true; do
    [ -n "$ARGS_PREFIX" ] && PREFIX="$ARGS_PREFIX" || reading "\n (4/5) $(text 14) " PREFIX
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
    hint "\n (5/5) $(text 15) "
    hint " $(text 16) "
    reading "\n $(text 38) " TLS_MODE
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

  # 等待 NodePass 和 QRencode 下载完成
  wait
  if [[ -s "$TEMP_DIR/nodepass" && -s "$TEMP_DIR/nodepass-core" && -s "$TEMP_DIR/qrencode" ]]; then
    info " $(text 19) "
  elif [[ ! -f "$TEMP_DIR/nodepass" && ! -f "$TEMP_DIR/qrencode" ]]; then
    local APP="NodePass, QRencode" && error "\n $(text 9) "
  elif [ ! -f "$TEMP_DIR/nodepass" ]; then
    local APP="NodePass" && error "\n $(text 9) "
  elif [ ! -f "$TEMP_DIR/qrencode" ]; then
    local APP="QRencode" && error "\n $(text 9) "
  fi

  # 构建命令行
  CMD="master://${CMD_SERVER_IP}:${PORT}/${PREFIX}?tls=${TLS_MODE}${CRT_PATH:-}"

  # 移动到工作目录，保存语言选择和服务器IP信息到单个文件
  mkdir -p $WORK_DIR
  echo -e "LANGUAGE=$L\nSERVER_IP=$SERVER_IP" > $WORK_DIR/data
  [[ "$IN_CONTAINER" = 1 || "$SERVICE_MANAGE" = "none" ]] && echo -e "CMD='$CMD'" >> $WORK_DIR/data
  grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT" && local REMOTE="${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${URL_SERVER_PORT}" && echo -e "REMOTE=$REMOTE" >> $WORK_DIR/data

  # 移动 NodePass稳定版、开发版和经典版，qrencode 可执行文件并设置权限
  mv $TEMP_DIR/nodepass $WORK_DIR/np-stb
  mv $TEMP_DIR/nodepass-core $WORK_DIR/np-dev
  mv $TEMP_DIR/nodepass-apt $WORK_DIR/np-lts
  mv $TEMP_DIR/qrencode $WORK_DIR/
  chmod +x $WORK_DIR/{np-stb,np-dev,np-lts,qrencode}

  # 根据选择不同的版本类型，设置 NodePass 的可执行文件的软链接
  case "$VERSION_TYPE_CHOICE" in
    2) ln -sf "$WORK_DIR/np-dev" "$WORK_DIR/nodepass" ;;
    3) ln -sf "$WORK_DIR/np-lts" "$WORK_DIR/nodepass" ;;
    *) ln -sf "$WORK_DIR/np-stb" "$WORK_DIR/nodepass" ;;
  esac

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
    get_uri
    info "\n $(text 10) "

    # 如是需要映射到公网的，则执行 api
    if grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT"; then
      # 生成8位随机数字作为alias
      local CLIENT_ALIAS=$(printf '%08d' $((RANDOM * RANDOM % 100000000)))

      # 执行 api
      if [ "$DOWNLOAD_TOOL" = "curl" ]; then
        local CREATE_NEW_INSTANCE_ID=$(curl -ksS -X 'POST' \
          "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances" \
          -H 'accept: application/json' \
          -H "X-API-Key: ${KEY}" \
          -H 'Content-Type: application/json' \
          -d "{
            \"url\": \"client://${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${TUNNEL_PORT_INPUT}/127.0.0.1:${PORT}?min=4\",
            \"alias\": \"${CLIENT_ALIAS}\"
          }" 2>&1 | sed 's/{"id":"\([0-9a-f]\{8\}\)".*/\1/')

        grep -q "^[0-9a-f]\{8\}$" <<< "${CREATE_NEW_INSTANCE_ID}" && curl -X 'PATCH' "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${CREATE_NEW_INSTANCE_ID}" \
          -H "X-API-KEY: ${KEY}" \
          -d '{ "restart": true }' >/dev/null 2>&1
      else
        local CREATE_NEW_INSTANCE_ID=$(wget --no-check-certificate -qO- --method=POST \
          --header="accept: application/json" \
          --header="X-API-Key: ${KEY}" \
          --header="Content-Type: application/json" \
          --body-data="{\"url\": \"client://${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${TUNNEL_PORT_INPUT}/127.0.0.1:${PORT}?min=4\", \"alias\": \"${CLIENT_ALIAS}\"}" \
          "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances" 2>&1 | sed 's/{"id":"\([0-9a-f]\{8\}\)".*/\1/')

        grep -q "^[0-9a-f]\{8\}$" <<< "${CREATE_NEW_INSTANCE_ID}" && wget --no-check-certificate --method=PATCH \
        --header="X-API-KEY: ${KEY}" \
        --body-data='{ "restart": true }' \
        "http://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${CREATE_NEW_INSTANCE_ID}" >/dev/null 2>&1
      fi

      [ "${#CREATE_NEW_INSTANCE_ID}" = 8 ] && echo -e "INSTANCE_ID=${CREATE_NEW_INSTANCE_ID}" >> $WORK_DIR/data && info "\n $(text 72) \n" || warning "\n $(text 73) \n"
    fi

    # 输出安装信息
    echo "------------------------"
    info " $(text 60) $(text 34) "
    info " $(text 35) "
    info " $(text 39) ${HTTP_S}://${URL_SERVER_IP}:${URL_SERVER_PORT}/${PREFIX}/v1"
    info " $(text 40) ${KEY}"
    info " $(text 90) $URI"
    grep -q '.' <<< "$TUNNEL_PORT_INPUT" && info " $(text 82) server://${REMOTE_PASSWORD_INPUT}:${TUNNEL_PORT_INPUT}/:${REMOTE_PORT_INPUT}"
    ${WORK_DIR}/qrencode "$URI"

    echo "------------------------"
  else
    warning " $(text 53) "
  fi

  help

  # 显示脚本使用情况数据
  # statistics_of_run-times get
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
Documentation=https://github.com/NodePassProject/nodepass
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
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    DOWNLOAD_COMMAND="curl -ksSL"
  else
    DOWNLOAD_COMMAND="wget --no-check-certificate -qO-"
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
change_intranet_penetration_server() {
  reading "\n $(text 75) " REMOTE_SERVER_INPUT
  until validate_ip_address "$REMOTE_SERVER_INPUT"; do
    reading "\n $(text 75) " REMOTE_SERVER_INPUT
  done

  [[ "$REMOTE_SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]] && REMOTE_SERVER_INPUT="[${REMOTE_SERVER_INPUT}]"

  # 如果输入了公网 IP，则需要进一步输入端口和认证密码
  if grep -q '.' <<< "$REMOTE_SERVER_INPUT"; then
    reading "\n $(text 81) " TUNNEL_PORT_INPUT
    while ! check_port "$TUNNEL_PORT_INPUT" "check_used"; do
      warning " $(text 41) "
      reading "\n $(text 81) " TUNNEL_PORT_INPUT
    done

    reading "\n $(text 69) " REMOTE_PORT_INPUT
    while ! check_port "$REMOTE_PORT_INPUT" "no_check_used"; do
      warning " $(text 41) "
      reading "\n $(text 69) " REMOTE_PORT_INPUT
    done

    reading "\n $(text 71) " REMOTE_PASSWORD_INPUT
    grep -q '.' <<< "$REMOTE_PASSWORD_INPUT" && REMOTE_PASSWORD_INPUT+="@"
  fi

  # 生成8位随机数字作为alias
  local CLIENT_ALIAS=$(printf '%08d' $((RANDOM * RANDOM % 100000000)))

  # 执行 api
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    # 修改内网穿透实例内容
    curl -ksS -X 'PUT' \
      "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" \
      -H 'accept: application/json' \
      -H "X-API-Key: ${KEY}" \
      -H 'Content-Type: application/json' \
      -d "{
        \"url\": \"client://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${TUNNEL_PORT_INPUT}/127.0.0.1:${PORT}?min=4\",
        \"alias\": \"${CLIENT_ALIAS}\"
      }" &>/dev/null
  else
    # 修改内网穿透实例内容
    wget --no-check-certificate -qO- --method=PUT \
      --header="accept: application/json" \
      --header="X-API-Key: ${KEY}" \
      --header="Content-Type: application/json" \
      --body-data="{\"url\": \"client://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${TUNNEL_PORT_INPUT}/127.0.0.1:${PORT}?min=4\", \"alias\": \"${CLIENT_ALIAS}\"}" \
      "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" &>/dev/null
  fi

  # 更新 data 文件
  if [ "$?" = 0 ]; then
    sed -i "s/^REMOTE=.*/REMOTE=${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${REMOTE_PORT_INPUT}/" $WORK_DIR/data
    local SERVER_CMD="server://${REMOTE_PASSWORD_INPUT}:${TUNNEL_PORT_INPUT}/:${REMOTE_PORT_INPUT}"
    info "\n $(text 76) \n"
    info " $(text 82) $SERVER_CMD\n"
    unset API_URL && get_uri output
  else
    error "\n $(text 77) \n"
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
    local RESPONSE=$(curl -ks -X 'PATCH' \
      "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances/********" \
      -H "accept: application/json" \
      -H "X-API-Key: ${KEY}" \
      -H "Content-Type: application/json" \
      -d '{"action": "restart"}')
  else
    local RESPONSE=$(wget --no-check-certificate -qO- --method=PATCH \
      "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances/********" \
      --header='accept: application/json' \
      --header="X-API-Key: ${KEY}" \
      --header='Content-Type: application/json' \
      --body-data='{"action":"restart"}')
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
    get_uri
    get_local_version all
    grep -q '.' <<< "$REMOTE" && get_intranet_penetration_server_cmd

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
      OPTION[4]="4. $(text 95) (np -t)"
      OPTION[5]="5. $(text 29) (np -u)"
      grep -q '.' <<< "$REMOTE" && OPTION[6]="6. $(text 70) (np -c)"
      OPTION[0]="0. $(text 31)"

      # 服务未开启时的动作
      ACTION[1]() { on_off $INSTALL_STATUS; exit 0; }
      ACTION[2]() { change_api_key; exit 0; }
      ACTION[3]() { upgrade_nodepass; exit 0; }
      ACTION[4]() { switch_nodepass_version; exit 0; }
      ACTION[5]() { uninstall; exit 0; }
      grep -q '.' <<< "$REMOTE" && ACTION[6]() { change_intranet_penetration_server; exit 0; }
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
│   >https://github.com/NodePassProject/nodepass   │
╰───────────────────────────────────────────╯ "

  grep -q '.' <<< "$DEV_LOCAL_VERSION" && grep -q '.' <<< "$STABLE_LOCAL_VERSION" && grep -q '.' <<< "$LTS_LOCAL_VERSION" && info " $(text 45) "
  grep -q '.' <<< "$DEV_LATEST_VERSION" && grep -q '.' <<< "$STABLE_LATEST_VERSION" && grep -q '.' <<< "$LTS_LATEST_VERSION" && info " $(text 46) "
  grep -q '.' <<< "$RUNNING_LOCAL_VERSION" && info " $VERSION_TYPE_TEXT $RUNNING_LOCAL_VERSION"
  grep -qEw '0|1' <<< "$INSTALL_STATUS" && info " $(text 60) $NODEPASS_STATUS "
  grep -q '.' <<< "$API_URL" && info " $(text 39) $API_URL"
  grep -q '.' <<< "$KEY" && info " $(text 40) $KEY"
  grep -q '.' <<< "$SERVER_CMD" && info " $(text 82) $SERVER_CMD"
  grep -q '.' <<< "$URI" && [ -x "${WORK_DIR}/qrencode" ] && info " $(text 90) $URI"
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

  # 处理旧应用的兼容性
  compatibility_old_binary

  # 统计脚本当天及累计使用次数
  # statistics_of_run-times update np.sh 2>/dev/null

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
    -t)
      # 版本切换操作
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || switch_nodepass_version
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
        grep -q '.' <<< "$REMOTE" && get_intranet_penetration_server_cmd output
        get_uri output
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
        change_intranet_penetration_server
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
