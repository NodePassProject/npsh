#!/usr/bin/env bash

SCRIPT_VERSION='0.0.7'

export DEBIAN_FRONTEND=noninteractive

GITHUB_PROXY=('https://v6.gh-proxy.org/' 'https://gh-proxy.com/' 'https://hub.glowp.xyz/' 'https://proxy.vvvv.ee/')

TEMP_DIR='/tmp/nodepass'
WORK_DIR='/etc/nodepass'

trap "rm -rf $TEMP_DIR >/dev/null 2>&1 ; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

E[0]="\n Language:\n 1. Default\n 2. English"
C[0]="${E[0]}"
E[1]="Doomsday Protocol"
C[1]="${E[1]}"
E[2]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback: [https://github.com/NodePassProject/npsh/issues]"
C[2]="${E[2]}"
E[3]="Unsupported architecture: \$(uname -m)"
C[3]="${E[3]}"
E[4]="Please choose: "
C[4]="${E[4]}"
E[5]="The script supports Linux systems only. Feedback: [https://github.com/NodePassProject/npsh/issues]"
C[5]="${E[5]}"
E[6]="NodePass help menu"
C[6]="${E[6]}"
E[7]="Install dependence-list:"
C[7]="${E[7]}"
E[8]="Failed to install download tool (curl). Please install wget or curl manually."
C[8]="${E[8]}"
E[9]="Failed to download \$APP"
C[9]="${E[9]}"
E[10]="NodePass installed successfully!"
C[10]="${E[10]}"
E[11]="NodePass has been uninstalled"
C[11]="${E[11]}"
E[12]="The external network of the current machine is single-stack:\\\n 1. \${SERVER_IPV4_DEFAULT}\${SERVER_IPV6_DEFAULT}\(default\)\\\n 2. Do not listen on the public network, only listen locally"
C[12]="${E[12]}"
E[13]="Please enter the port (1024-65535, NAT machine must use an open port, press Enter for random port):"
C[13]="${E[13]}"
E[14]="Please enter API prefix (lowercase letters, numbers and / only, press Enter for default \"api\"):"
C[14]="${E[14]}"
E[15]="Please select TLS mode (press Enter for none TLS encryption):"
C[15]="${E[15]}"
E[16]="0. None TLS encryption (plain TCP) - Fastest performance, no overhead (default)\n 1. Self-signed certificate (auto-generated) - Fine security with simple setups\n 2. Custom certificate (requires pre-prepared crt and key files) - Highest security with certificate validation"
C[16]="${E[16]}"
E[17]="Please enter the correct option"
C[17]="${E[17]}"
E[18]="NodePass is already installed, please uninstall it before reinstalling"
C[18]="${E[18]}"
E[19]="NodePass Stable \$STABLE_LATEST_VERSION, Development \$DEV_LATEST_VERSION and QRencode have been downloaded."
C[19]="${E[19]}"
E[20]="Failed to get latest version"
C[20]="${E[20]}"
E[21]="Running in container environment, skipping service creation and starting process directly"
C[21]="${E[21]}"
E[22]="NodePass Script Usage:\n np - Show menu\n np -i - Install NodePass\n np -u - Uninstall NodePass\n np -v - Upgrade NodePass\n np -t - Switch NodePass version between stable and development\n np -o - Toggle service status (start/stop)\n np -k - Change NodePass API key\n np -c - Change intranet penetration server\n np -s - Show NodePass API info\n np -h - Show help information"
C[22]="${E[22]}"
E[23]="Please enter the path to your TLS certificate file:"
C[23]="${E[23]}"
E[24]="Please enter the path to your TLS private key file:"
C[24]="${E[24]}"
E[25]="Certificate file does not exist:"
C[25]="${E[25]}"
E[26]="Private key file does not exist:"
C[26]="${E[26]}"
E[27]="Using custom TLS certificate"
C[27]="${E[27]}"
E[28]="Install"
C[28]="${E[28]}"
E[29]="Uninstall"
C[29]="${E[29]}"
E[30]="Upgrade core"
C[30]="${E[30]}"
E[31]="Exit"
C[31]="${E[31]}"
E[32]="not installed"
C[32]="${E[32]}"
E[33]="stopped"
C[33]="${E[33]}"
E[34]="running"
C[34]="${E[34]}"
E[35]="NodePass Installation Information:"
C[35]="${E[35]}"
E[36]="Port is already in use, please try another one."
C[36]="${E[36]}"
E[37]="Using random port:"
C[37]="${E[37]}"
E[38]="Please select: "
C[38]="${E[38]}"
E[39]="API URL:"
C[39]="${E[39]}"
E[40]="API KEY:"
C[40]="${E[40]}"
E[41]="Invalid port number, please enter a number between 1024 and 65535."
C[41]="${E[41]}"
E[42]="NodePass service has been stopped"
C[42]="${E[42]}"
E[43]="NodePass service has been started"
C[43]="${E[43]}"
E[44]="Unable to get local version"
C[44]="${E[44]}"
E[45]="NodePass Local Core: Stable \$STABLE_LOCAL_VERSION Dev \$DEV_LOCAL_VERSION"
C[45]="${E[45]}"
E[46]="NodePass Latest Core: Stable \$STABLE_LATEST_VERSION Dev \$DEV_LATEST_VERSION"
C[46]="${E[46]}"
E[47]="Current version is already the latest, no need to upgrade"
C[47]="${E[47]}"
E[48]="Found new version, upgrade? (y/N)"
C[48]="${E[48]}"
E[49]="Upgrade cancelled"
C[49]="${E[49]}"
E[50]="Stopping NodePass service..."
C[50]="${E[50]}"
E[51]="Starting NodePass service..."
C[51]="${E[51]}"
E[52]="NodePass upgrade successful!"
C[52]="${E[52]}"
E[53]="Failed to start NodePass service, please check logs"
C[53]="${E[53]}"
E[54]="Rolled back to previous version"
C[54]="${E[54]}"
E[55]="Rollback failed, please check manually"
C[55]="${E[55]}"
E[56]="Stop API"
C[56]="${E[56]}"
E[57]="Create shortcuts successfully: script can be run with [ np ] command, and [ nodepass ] binary is directly executable."
C[57]="${E[57]}"
E[58]="Start API"
C[58]="${E[58]}"
E[59]="NodePass is not installed. Configuration file not found"
C[59]="${E[59]}"
E[60]="NodePass API:"
C[60]="${E[60]}"
E[61]="PREFIX can only contain lowercase letters, numbers, and slashes (/), please re-enter"
C[61]="${E[61]}"
E[62]="Change KEY"
C[62]="${E[62]}"
E[63]="API KEY changed successfully!"
C[63]="${E[63]}"
E[64]="Failed to change API KEY"
C[64]="${E[64]}"
E[65]="Changing NodePass API KEY..."
C[65]="${E[65]}"
E[66]="Current running version: Development Version"
C[66]="${E[66]}"
E[67]="Current running version: Stable Version"
C[67]="${E[67]}"
E[68]="Please enter the IP of the public machine (leave blank to not penetrate):"
C[68]="${E[68]}"
E[69]="Please enter the port of the public machine:"
C[69]="${E[69]}"
E[70]="Change intranet penetration server"
C[70]="${E[70]}"
E[71]="Please enter the password (default is no password):"
C[71]="${E[71]}"
E[72]="The service of intranet penetration to remote has been created successfully"
C[72]="${E[72]}"
E[73]="API intranet penetration server creation failed!"
C[73]="${E[73]}"
E[74]="Not a valid IPv4,IPv6 address or domain name"
C[74]="${E[74]}"
E[75]="Please enter the IP of the intranet penetration server:"
C[75]="${E[75]}"
E[76]="Successfully modified the intranet penetration instance"
C[76]="${E[76]}"
E[77]="Failed to modify the intranet penetration instance"
C[77]="${E[77]}"
E[78]="The external network of the current machine is dual-stack:\\\n 1. \${SERVER_IPV4_DEFAULT}，listen all stacks \(default\)\\\n 2. \${SERVER_IPV6_DEFAULT}，listen all stacks\\\n 3. Do not listen on the public network, only listen locally"
C[78]="${E[78]}"
E[79]="Please select or enter the domain or IP directly:"
C[79]="${E[79]}"
E[80]="The script runs today: \$TODAY. Total: \$TOTAL"
C[80]="${E[80]}"
E[81]="Please enter the port on the server that the local machine will connect to for the tunnel (1024–65535):"
C[81]="${E[81]}"
E[82]="Running the service of intranet penetration on the server side:"
C[82]="${E[82]}"
E[83]="Failed to retrieve intranet penetration instance. Instance ID: \${INSTANCE\_ID}"
C[83]="${E[83]}"
E[84]="Please select the NodePass core to run. Use [np -t] to switch after installation:\\\n 1. Stable \$STABLE_LATEST_VERSION \(NodePassProject/nodepass\) - Suitable for production environments \(default\)\\\n 2. Development \$DEV_LATEST_VERSION \(NodePassProject/nodepass-core\) - Contains latest features, may be unstable"
C[84]="${E[84]}"
E[85]="Getting machine IP address..."
C[85]="${E[85]}"
E[86]="Switching NodePass version..."
C[86]="${E[86]}"
E[87]="Switched successfully"
C[87]="${E[87]}"
E[88]="Please select the version to switch to (default is 3):"
C[88]="${E[88]}"
E[89]="NodePass version switch failed"
C[89]="${E[89]}"
E[90]="URI:"
C[90]="${E[90]}"
E[91]="No upgrade available for both stable and development versions"
C[91]="${E[91]}"
E[92]="Stable version can be upgraded from \$STABLE_LOCAL_VERSION to \$STABLE_LATEST_VERSION"
C[92]="${E[92]}"
E[93]="Development version can be upgraded from \$DEV_LOCAL_VERSION to \$DEV_LATEST_VERSION"
C[93]="${E[93]}"
E[94]="Stable or development version has available updates"
C[94]="${E[94]}"
E[95]="Switch core version"
C[95]="${E[95]}"
E[96]="Waiting 5 seconds before starting the service..."
C[96]="${E[96]}"
E[97]="Current running version:"
C[97]="${E[97]}"
E[98]="Switch to stable version (np-stb)"
C[98]="${E[98]}"
E[99]="Switch to development version (np-dev)"
C[99]="${E[99]}"
E[100]="Cancel switching"
C[100]="${E[100]}"
E[101]="Please select the version to switch to (default is 2):"
C[101]="${E[101]}"

warning() { echo -e "\033[31m\033[01m$*\033[0m"; }
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; }
info() { echo -e "\033[32m\033[01m$*\033[0m"; }
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

help() {
  hint " ${E[22]} "
}

check_root() {
  [ "$(id -u)" != 0 ] && error " $(text 2) "
}

check_system() {
  [ "$(uname -s)" != "Linux" ] && error " $(text 5) "

  check_system_info

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

  [ "$IN_CONTAINER" = 1 ] && SERVICE_MANAGE="none"
}

check_install() {
  if [ ! -f "$WORK_DIR/nodepass" ]; then
    return 2
  else
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
      if pgrep -laf "nodepass" | grep -vE "grep|<defunct>" | grep -q "nodepass"; then
        return 0
      else
        return 1
      fi
    else
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
    if [ -f "/var/run/nodepass.pid" ] && kill -0 $(cat "/var/run/nodepass.pid" 2>/dev/null) >/dev/null 2>&1; then
      return 0
    else
      return 1
    fi
  else
    return 0
  fi
}

check_dependencies() {
  DEPS_INSTALL=()

  if [ -x "$(type -p curl)" ]; then
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  elif [ -x "$(type -p wget)" ]; then
    DOWNLOAD_TOOL="wget"
    DOWNLOAD_CMD="wget -q"
    grep -qi 'alpine' <<< "$SYSTEM" && grep -qi 'busybox' <<< "$(wget 2>&1 | head -n 1)" && apk add --no-cache wget >/dev/null 2>&1
  else
    DEPS_INSTALL+=("curl")
    DOWNLOAD_TOOL="curl"
    DOWNLOAD_CMD="curl -sL"
  fi

  if [ ! -x "$(type -p ps)" ] && [ ! -x "$(type -p pkill)" ]; then
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

check_system_info() {
  case "$(uname -m)" in
    x86_64 | amd64 ) ARCH=amd64 ;;
    armv8 | arm64 | aarch64 ) ARCH=arm64 ;;
    armv7l ) ARCH=arm ;;
    s390x ) ARCH=s390x ;;
    * ) error " $(text 3) " ;;
  esac

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

  if [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup; then
    IN_CONTAINER=1
  else
    IN_CONTAINER=0
  fi
}

validate_ip_address() {
  local IP="$1"
  local IPV4_REGEX='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
  local IPV6_REGEX='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'
  local DOMAIN_REGEX='^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'

  [ "$IP" = "localhost" ] && IP="127.0.0.1"
  if [[ "$IP" =~ $IPV4_REGEX ]] || [[ "$IP" =~ $IPV6_REGEX ]] || [[ "$IP" =~ $DOMAIN_REGEX ]]; then
    return 0
  else
    warning " $(text 74) "
    return 1
  fi
}

check_port() {
  local PORT=$1
  local NO_CHECK_USED=$2
  if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
    return 2
  fi

  if ! grep -q 'no_check_used' <<< "$NO_CHECK_USED"; then
    if [ $(type -p nc) ]; then
      nc -z 127.0.0.1 "$PORT" >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1
      fi
    elif [ $(type -p lsof) ]; then
      lsof -i:"$PORT" >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1
      fi
    elif [ $(type -p netstat) ]; then
      netstat -nltup 2>/dev/null | grep -q ":$PORT "
      if [ $? -eq 0 ]; then
        return 1
      fi
    elif [ $(type -p ss) ]; then
      ss -nltup 2>/dev/null | grep -q ":$PORT "
      if [ $? -eq 0 ]; then
        return 1
      fi
    else
      (echo >/dev/tcp/127.0.0.1/"$PORT") >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        return 1
      fi
    fi

    return 0
  fi
}

check_cdn() {
  for PROXY_URL in "${GITHUB_PROXY[@]}"; do
    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
      REMOTE_VERSION=$(curl -ksL --connect-timeout 3 --max-time 3 ${PROXY_URL}https://raw.githubusercontent.com/NodePassProject/npsh/refs/heads/main/README.md 2>/dev/null | sed -nE 's/^-[ ]+(Stable|Development):/\1:/p')
    else
      REMOTE_VERSION=$(wget -qO- --no-check-certificate --tries=2 --timeout=3 ${PROXY_URL}https://raw.githubusercontent.com/NodePassProject/npsh/refs/heads/main/README.md 2>/dev/null | sed -nE 's/^-[ ]+(Stable|Development):/\1:/p')
    fi
    grep -q 'Stable' <<< "$REMOTE_VERSION" && GH_PROXY="$PROXY_URL" && break
  done
}

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

select_language() {
  UTF8_LOCALE=$(locale -a 2>/dev/null | grep -iEm1 "UTF-8|utf8")
  [ -n "$UTF8_LOCALE" ] && export LC_ALL="$UTF8_LOCALE" LANG="$UTF8_LOCALE" LANGUAGE="$UTF8_LOCALE"

  if [ -n "$ARGS_LANGUAGE" ]; then
    case "$ARGS_LANGUAGE" in
      1|zh|CN|cn|chinese|C|c)
        L=C
        ;;
      2|en|EN|english|E|e)
        L=E
        ;;
      *)
        L=C
        ;;
    esac
  elif [ -s ${WORK_DIR}/data ]; then
    source ${WORK_DIR}/data
    L=$LANGUAGE
  else
    L=C && hint " $(text 0) \n" && reading " $(text 4) " LANGUAGE_CHOICE
    [ "$LANGUAGE_CHOICE" = 2 ] && L=E
  fi
}

get_api_url() {
  [ -s "$WORK_DIR/data" ] && source "$WORK_DIR/data"

  if [ -s "$WORK_DIR/gob/nodepass.gob" ]; then
    if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
      if [ -s "$WORK_DIR/data" ] && grep -q "CMD=" "$WORK_DIR/data" ]; then
        local CMD_LINE=$(grep "CMD=" "$WORK_DIR/data" | cut -d= -f2-)
      else
        if [ $(type -p pgrep) ]; then
          local CMD_LINE=$(pgrep -af "nodepass" | grep -v "grep\|sed\|<defunct>" | sed -n 's/.*nodepass \(.*\)/\1/p')
        else
          local CMD_LINE=$(ps -ef | grep -v "grep\|sed\|<defunct>" | grep "nodepass" | sed -n 's/.*nodepass \(.*\)/\1/p')
        fi
      fi
    elif [ "$SERVICE_MANAGE" = "systemctl" ] && [ -s "/etc/systemd/system/nodepass.service" ]; then
      local CMD_LINE=$(sed -n 's/.*ExecStart=.*\(master.*\)"/\1/p' "/etc/systemd/system/nodepass.service")
    elif [ "$SERVICE_MANAGE" = "rc-service" ] && [ -s "/etc/init.d/nodepass" ]; then
      local CMD_LINE=$(sed -n 's/.*command_args.*\(master.*\)/\1/p' "/etc/init.d/nodepass")
    elif [ "$SERVICE_MANAGE" = "init.d" ] && [ -s "/etc/init.d/nodepass" ]; then
      local CMD_LINE=$(sed -n 's/^CMD="\([^"]\+\)"/\1/p' "/etc/init.d/nodepass")
    fi

    if [ -n "$CMD_LINE" ]; then
      [[ "$CMD_LINE" =~ master://.*:([0-9]+)/([^?]+)\?(log=[^&]+&)?tls=([0-2]) ]]
      PORT="${BASH_REMATCH[1]}"
      PREFIX="${BASH_REMATCH[2]}"
      TLS_MODE="${BASH_REMATCH[4]}"
      grep -qw '0' <<< "$TLS_MODE" && local HTTP_S="http" || local HTTP_S="https"
    fi

    if grep -q '.' <<< "$REMOTE"; then
      [[ $REMOTE =~ (.*@)?(.*):([0-9]+)$ ]]
      local URL_SERVER_PASSWORD="${BASH_REMATCH[1]}"
      local URL_SERVER_IP="${BASH_REMATCH[2]}"
      URL_SERVER_PORT="${BASH_REMATCH[3]}"
    else
      local URL_SERVER_PORT=$(sed -n 's#.*:\([0-9]\+\)\/.*#\1#p' <<< "$CMD_LINE")
      grep -q ':' <<< "$SERVER_IP" && local URL_SERVER_IP="[$SERVER_IP]" || local URL_SERVER_IP="$SERVER_IP"
    fi

    API_URL="${HTTP_S}://${URL_SERVER_IP}:${URL_SERVER_PORT}/${PREFIX:+${PREFIX%/}/}v1"
    grep -q 'output' <<< "$1" && info " $(text 39) $API_URL "
  else
    warning " $(text 59) "
  fi
}

get_api_key() {
  if [ -s "$WORK_DIR/gob/nodepass.gob" ]; then
    KEY=$(grep -a -o '[0-9a-f]\{32\}' $WORK_DIR/gob/nodepass.gob)
    grep -q 'output' <<< "$1" && info " $(text 40) $KEY"
  else
    warning " $(text 59) "
  fi
}

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

get_uri() {
  grep -q '^$' <<< "$API_URL" && get_api_url
  grep -q '^$' <<< "$KEY" && get_api_key

  URI="np://master?url=$(echo -n "$API_URL" | base64 -w0)&key=$(echo -n "$KEY" | base64 -w0)"

  grep -q 'output' <<< "$1" && grep -q '.' <<< "$URI" && info " $(text 90) $URI" && ${WORK_DIR}/qrencode "$URI"
}

get_random_port() {
  local RANDOM_PORT
  while true; do
    RANDOM_PORT=$((RANDOM % 7168 + 1024))
    check_port "$RANDOM_PORT" "check_used" && break
  done
  echo "$RANDOM_PORT"
}

get_local_version() {
  if grep -qw 'all' <<< "$1"; then
    [ -f "$WORK_DIR/np-dev" ] && DEV_LOCAL_VERSION=$(${WORK_DIR}/np-dev 2>&1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*') || DEV_LOCAL_VERSION=""
    [ -f "$WORK_DIR/np-stb" ] && STABLE_LOCAL_VERSION=$(${WORK_DIR}/np-stb 2>&1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*') || STABLE_LOCAL_VERSION=""
  fi
  local GET_SYMLINK_TARGET=$(readlink ${WORK_DIR}/nodepass 2>/dev/null)
  if grep -q 'np-dev' <<< "$GET_SYMLINK_TARGET"; then
    VERSION_TYPE_TEXT=$(text 66)
  elif grep -q 'np-stb' <<< "$GET_SYMLINK_TARGET"; then
    VERSION_TYPE_TEXT=$(text 67)
  fi
  RUNNING_LOCAL_VERSION=$(${WORK_DIR}/nodepass 2>&1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^[:space:]]*')
}

get_latest_version() {
  STABLE_LATEST_VERSION=$(awk -F '[ ]' '/Stable/{print $NF}' <<< "$REMOTE_VERSION")
  DEV_LATEST_VERSION=$(awk -F '[ ]' '/Development/{print $NF}' <<< "$REMOTE_VERSION")

  [[ -z "$STABLE_LATEST_VERSION" || -z "$DEV_LATEST_VERSION" ]] && error " $(text 20) "

  STABLE_VERSION_NUM=${STABLE_LATEST_VERSION#v}
  DEV_VERSION_NUM=${DEV_LATEST_VERSION#v}
}

on_off() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      if pgrep -laf "nodepass" | grep -vE "<defunct>|grep" | grep -q "nodepass"; then
        RUNNING=1
      else
        RUNNING=0
      fi
    else
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

  if [ "$RUNNING" = 1 ]; then
    stop_nodepass
    info " $(text 42) "
  else
    start_nodepass
    info " $(text 43) "
  fi
}

start_nodepass() {
  info " $(text 51) "

  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
    if [ $(type -p pgrep) ]; then
      ZOMBIE_PIDS=$(pgrep -f "nodepass" | xargs ps -p 2>/dev/null | grep "<defunct>" | awk '{print $1}')
      [ -n "$ZOMBIE_PIDS" ] && echo "$ZOMBIE_PIDS" | xargs -r kill -9 >/dev/null 2>&1
    else
      ZOMBIE_PIDS=$(ps -ef | grep -v grep | grep "nodepass" | grep "<defunct>" | awk '{print $2}')
      [ -n "$ZOMBIE_PIDS" ] && echo "$ZOMBIE_PIDS" | xargs -r kill -9 >/dev/null 2>&1
    fi

    if [ -s "$WORK_DIR/data" ] && grep -q "CMD=" "$WORK_DIR/data"; then
      source "$WORK_DIR/data"
    else
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

stop_nodepass() {
  info " $(text 50) "
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
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

compatibility_old_binary() {
  [ -f "$WORK_DIR/stable-nodepass" ] && mv "$WORK_DIR/stable-nodepass" "$WORK_DIR/np-stb"
  [ -f "$WORK_DIR/dev-nodepass" ] && mv "$WORK_DIR/dev-nodepass" "$WORK_DIR/np-dev"

  if [ -L "$WORK_DIR/nodepass" ]; then
    local CURRENT_SYMLINK=$(readlink "$WORK_DIR/nodepass")
    if [[ "$CURRENT_SYMLINK" == *"stable-nodepass"* ]]; then
      ln -sf "$WORK_DIR/np-stb" "$WORK_DIR/nodepass"
    elif [[ "$CURRENT_SYMLINK" == *"dev-nodepass"* ]]; then
      ln -sf "$WORK_DIR/np-dev" "$WORK_DIR/nodepass"
    fi
  fi

  if [ -d $WORK_DIR ] && [ -f "$WORK_DIR/np-lts" ]; then
    rm -f "$WORK_DIR/np-lts"
  fi
}

upgrade_nodepass() {
  get_local_version all

  get_latest_version

  info "\n $(text 45) "
  info " $(text 46) "

  local HAS_UPGRADE=0
  local HAS_STABLE_UPGRADE=0
  local HAS_DEV_UPGRADE=0

  local OPTION_INDEX=1
  local AVAILABLE_INDICES=()

  local UPGRADE_INFO=""

  if [ -f "$WORK_DIR/np-stb" ] && [ -n "$STABLE_LATEST_VERSION" ] && [ "$STABLE_LOCAL_VERSION" != "$STABLE_LATEST_VERSION" ]; then
    HAS_UPGRADE=1
    HAS_STABLE_UPGRADE=1
    UPGRADE_INFO+="\n $(text 92) "
  fi

  if [ -f "$WORK_DIR/np-dev" ] && [ -n "$DEV_LATEST_VERSION" ] && [ "$DEV_LOCAL_VERSION" != "$DEV_LATEST_VERSION" ]; then
    HAS_UPGRADE=1
    HAS_DEV_UPGRADE=1
    UPGRADE_INFO+="\n $(text 93) "
  fi

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

  local NEED_RESTART=0

  if [ "$VERSION_TYPE_TEXT" = "$(text 67)" ] && [ "$HAS_STABLE_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  elif [ "$VERSION_TYPE_TEXT" = "$(text 66)" ] && [ "$HAS_DEV_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  elif [ "$HAS_STABLE_UPGRADE" = 1 ] && [ "$HAS_DEV_UPGRADE" = 1 ]; then
    NEED_RESTART=1
  fi

  [ "$NEED_RESTART" = 1 ] && stop_nodepass

  [ "$HAS_STABLE_UPGRADE" = 1 ] && cp "$WORK_DIR/np-stb" "$WORK_DIR/np-stb.old" 2>/dev/null
  [ "$HAS_DEV_UPGRADE" = 1 ] && cp "$WORK_DIR/np-dev" "$WORK_DIR/np-dev.old" 2>/dev/null

  local DOWNLOAD_SUCCESS=1

  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    if [ "$HAS_STABLE_UPGRADE" = 1 ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass" ]; then
        mv "$TEMP_DIR/nodepass" "$WORK_DIR/np-stb"
        chmod +x "$WORK_DIR/np-stb"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    if [ "$HAS_DEV_UPGRADE" = 1 ]; then
      curl -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-core" ]; then
        mv "$TEMP_DIR/nodepass-core" "$WORK_DIR/np-dev"
        chmod +x "$WORK_DIR/np-dev"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi
  else
    if [ "$HAS_STABLE_UPGRADE" = 1 ]; then
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass" ]; then
        mv "$TEMP_DIR/nodepass" "$WORK_DIR/np-stb"
        chmod +x "$WORK_DIR/np-stb"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi

    if [ "$HAS_DEV_UPGRADE" = 1 ]; then
      wget "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"
      if [ -f "$TEMP_DIR/nodepass-core" ]; then
        mv "$TEMP_DIR/nodepass-core" "$WORK_DIR/np-dev"
        chmod +x "$WORK_DIR/np-dev"
      else
        DOWNLOAD_SUCCESS=0
      fi
    fi
  fi

  if [ "$DOWNLOAD_SUCCESS" = 0 ]; then
    warning " $(text 9) "
    [ -s $WORK_DIR/np-stb.old ] && mv "$WORK_DIR/np-stb.old" "$WORK_DIR/np-stb" 2>/dev/null
    [ -s $WORK_DIR/np-dev.old ] && mv "$WORK_DIR/np-dev.old" "$WORK_DIR/np-dev" 2>/dev/null

    [ "$NEED_RESTART" = 1 ] && info " $(text 54) " && start_nodepass
    return 1
  fi

  if [ "$NEED_RESTART" = 1 ]; then
    info " $(text 96) " && sleep 5
    if start_nodepass; then
      info " $(text 52) "
      rm -f "$WORK_DIR/np-stb.old" "$WORK_DIR/np-dev.old"
    else
      warning " $(text 53) "
      mv "$WORK_DIR/np-stb.old" "$WORK_DIR/np-stb" 2>/dev/null
      mv "$WORK_DIR/np-dev.old" "$WORK_DIR/np-dev" 2>/dev/null
      if start_nodepass; then
        info " $(text 54) "
      else
        error " $(text 55) "
      fi
    fi
  else
    info " $(text 52) "
    rm -f "$WORK_DIR/np-stb.old" "$WORK_DIR/np-dev.old"
  fi
}

switch_nodepass_version() {
  if [ ! -f "$WORK_DIR/np-stb" ] && [ ! -f "$WORK_DIR/np-dev" ]; then
    warning " $(text 59) "
    return 1
  fi

  info " $(text 86) "

  get_local_version all

  [ -L "$WORK_DIR/nodepass" ] && cp -f "$WORK_DIR/nodepass" "$WORK_DIR/nodepass.bak"

  info "\n $(text 97) $VERSION_TYPE_TEXT $RUNNING_LOCAL_VERSION"

  VERSION_TYPE_TEXT_ARRAY=("$(text 67)" "$(text 66)")
  VERSION_NAMES=("stable" "development")
  VERSION_FILES=("$WORK_DIR/np-stb" "$WORK_DIR/np-dev")
  VERSION_TEXTS=("$(text 67)" "$(text 66)")
  VERSION_LOCAL_VERSIONS=("$STABLE_LOCAL_VERSION" "$DEV_LOCAL_VERSION")
  VERSION_DISPLAY_TEXTS=("$(text 98)" "$(text 99)")

  for i in "${!VERSION_TYPE_TEXT_ARRAY[@]}"; do
    [ "$VERSION_TYPE_TEXT" = "${VERSION_TYPE_TEXT_ARRAY[$i]}" ] && CURRENT_INDEX=$i && break
  done

  local OPTION_INDEX=1
  local AVAILABLE_INDICES=()

  for i in "${!VERSION_NAMES[@]}"; do
    if [ "$i" != "$CURRENT_INDEX" ]; then
      hint " $OPTION_INDEX. ${VERSION_DISPLAY_TEXTS[$i]} ${VERSION_LOCAL_VERSIONS[$i]}"
      AVAILABLE_INDICES+=($i)
      ((OPTION_INDEX++))
    fi
  done

  hint " 2. $(text 100)"
  reading "\n $(text 101) " SWITCH_CHOICE
  SWITCH_CHOICE=${SWITCH_CHOICE:-2}

  case "$SWITCH_CHOICE" in
    1)
      TARGET_INDEX=${AVAILABLE_INDICES[0]}
      TARGET_VERSION=${VERSION_NAMES[$TARGET_INDEX]}
      TARGET_FILE=${VERSION_FILES[$TARGET_INDEX]}
      TARGET_TEXT=${VERSION_TEXTS[$TARGET_INDEX]}
      ;;
    *)
      info " $(text 100)"
      return 0
      ;;
  esac

  stop_nodepass

  ln -sf "$TARGET_FILE" "$WORK_DIR/nodepass"

  info " $(text 96) " && sleep 5

  if start_nodepass; then
    get_local_version running
    info " $(text 87)\n $TARGET_TEXT $RUNNING_LOCAL_VERSION"
  else
    warning " $(text 89) "
    [ -f "$WORK_DIR/nodepass.bak" ] && cp -f "$WORK_DIR/nodepass.bak" "$WORK_DIR/nodepass" && start_nodepass
  fi

  rm -f "$WORK_DIR/nodepass.bak"
}

parse_args() {
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

install() {
  handle_ip_input() {
    local IP="$1"

    unset SERVER_INPUT

    IP=$(sed 's/[][]//g' <<< "$IP")

    if [[ "$IP" = "localhost" || "$IP" = "127.0.0.1" || "$IP" = "::1" ]]; then
      SERVER_INPUT="127.0.0.1"
    else
      if grep -q '.' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '.' <<< "${SERVER_IPV6_DEFAULT}"; then
        case "$IP" in
          1|"") SERVER_INPUT="${SERVER_IPV4_DEFAULT}" ;;
          2) SERVER_INPUT="${SERVER_IPV6_DEFAULT}" ;;
          3) SERVER_INPUT="127.0.0.1" ;;
          *) SERVER_INPUT="$IP" ;;
        esac
      elif ( grep -q '.' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '^$' <<< "${SERVER_IPV6_DEFAULT}" ) || ( grep -q '^$' <<< "${SERVER_IPV4_DEFAULT}" && grep -q '.' <<< "${SERVER_IPV6_DEFAULT}" ); then
        case "$IP" in
          1|"") SERVER_INPUT="${SERVER_IPV4_DEFAULT}${SERVER_IPV6_DEFAULT}" ;;
          2) SERVER_INPUT="127.0.0.1" ;;
          *) SERVER_INPUT="$IP" ;;
        esac

      else
        SERVER_INPUT="$IP"
      fi
    fi
  }

  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    { curl --connect-timeout 60 --max-time 60 --retry 2 -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"; } &
    { curl --connect-timeout 60 --max-time 60 --retry 2 -sL "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" | tar -xz -C "$TEMP_DIR"; } &
    { curl --connect-timeout 60 --max-time 60 --retry 2 -o "$TEMP_DIR/qrencode" "${GH_PROXY}https://github.com/fscarmen/client_template/raw/main/qrencode-go/qrencode-go-linux-$ARCH" >/dev/null 2>&1 && chmod +x "$TEMP_DIR/qrencode" >/dev/null 2>&1; } &
  else
    { wget --timeout=60 --tries=2 "${GH_PROXY}https://github.com/NodePassProject/nodepass-core/releases/download/${DEV_LATEST_VERSION}/nodepass-core_${DEV_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"; } &
    { wget --timeout=60 --tries=2 "${GH_PROXY}https://github.com/NodePassProject/nodepass/releases/download/${STABLE_LATEST_VERSION}/nodepass_${STABLE_VERSION_NUM}_linux_${ARCH}.tar.gz" -qO- | tar -xz -C "$TEMP_DIR"; } &
    { wget --no-check-certificate --timeout=60 --tries=2 --continue -qO "$TEMP_DIR/qrencode" "${GH_PROXY}https://github.com/fscarmen/client_template/raw/main/qrencode-go/qrencode-go-linux-$ARCH" >/dev/null 2>&1 && chmod +x "$TEMP_DIR/qrencode" >/dev/null 2>&1; } &
  fi
  rm -f $TEMP_DIR/{README.md,README_zh.md,LICENSE}

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

    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
      grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local SERVER_IPV4_DEFAULT=$(curl -s $BIND_ADDRESS4 --retry 2 --max-time 3 http://api-ipv4.ip.sb || curl -s $BIND_ADDRESS4 --retry 2 --max-time 3 http://ipv4.icanhazip.com)
      grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local SERVER_IPV6_DEFAULT=$(curl -s $BIND_ADDRESS6 --retry 2 --max-time 3 http://api-ipv6.ip.sb || curl -s $BIND_ADDRESS6 --retry 2 --max-time 3 http://ipv6.icanhazip.com)
    else
      grep -q '.' <<< "$DEFAULT_LOCAL_IP4" && local SERVER_IPV4_DEFAULT=$(wget -qO- $BIND_ADDRESS4 --tries=2 --timeout=3 http://api-ipv4.ip.sb || wget -qO- $BIND_ADDRESS4 --tries=2 --timeout=3 http://ipv4.icanhazip.com)
      grep -q '.' <<< "$DEFAULT_LOCAL_IP6" && local SERVER_IPV6_DEFAULT=$(wget -qO- $BIND_ADDRESS6 --tries=2 --timeout=3 http://api-ipv6.ip.sb || wget -qO- $BIND_ADDRESS6 --tries=2 --timeout=3 http://ipv6.icanhazip.com)
    fi
  fi

  case "$VERSION_TYPE_CHOICE" in
    dev ) VERSION_TYPE_CHOICE="2" ;;
    stable ) VERSION_TYPE_CHOICE="1" ;;
  esac

  grep -q '^$' <<< "$VERSION_TYPE_CHOICE" && hint "\n (1/5) $(text 84) \n" && reading " $(text 4) " VERSION_TYPE_CHOICE

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

  while true; do
    [ -n "$ARGS_PORT" ] && PORT="$ARGS_PORT" || reading "\n (3/5) $(text 13) " PORT
    if [ -z "$PORT" ]; then
      PORT=$(get_random_port)
      info " $(text 37) $PORT"
      break
    else
      check_port "$PORT" "check_used"
      local PORT_STATUS=$?

      if [ "$PORT_STATUS" = 2 ]; then
        unset ARGS_PORT PORT
        warning " $(text 41) "
      elif [ "$PORT_STATUS" = 1 ]; then
        unset ARGS_PORT PORT
        warning " $(text 36) "
      else
        break
      fi
    fi
  done

  if grep -q '127.0.0.1' <<< "$SERVER_INPUT"; then
    [ -z "$ARGS_REMOTE_SERVER_IP" ] && reading "\n $(text 68) " REMOTE_SERVER_INPUT
    REMOTE_SERVER_INPUT=$(sed 's/[][]//g' <<< "$REMOTE_SERVER_INPUT")
    REMOTE_SERVER_INPUT=${REMOTE_SERVER_INPUT:-"127.0.0.1"}
    until validate_ip_address "$REMOTE_SERVER_INPUT"; do
      reading "\n $(text 68) " REMOTE_SERVER_INPUT
      REMOTE_SERVER_INPUT=$(sed 's/[][]//g' <<< "$REMOTE_SERVER_INPUT")
    done

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

  while true; do
    [ -n "$ARGS_PREFIX" ] && PREFIX="$ARGS_PREFIX" || reading "\n (4/5) $(text 14) " PREFIX
    [ -z "$PREFIX" ] && PREFIX="api" && break
    if grep -q '^[a-z0-9/]*$' <<< "$PREFIX"; then
      PREFIX=$(sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s#^/##;s#/$##' <<< "$PREFIX")
      break
    else
      unset ARGS_PREFIX PREFIX
      warning " $(text 61) "
    fi
  done
  [ -z "$PREFIX" ] && PREFIX="api"

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

  if [ "$TLS_MODE" = "2" ]; then
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

  CMD="master://${CMD_SERVER_IP}:${PORT}/${PREFIX}?tls=${TLS_MODE}${CRT_PATH:-}"

  mkdir -p $WORK_DIR
  echo -e "LANGUAGE=$L\nSERVER_IP=$SERVER_IP" > $WORK_DIR/data
  [[ "$IN_CONTAINER" = 1 || "$SERVICE_MANAGE" = "none" ]] && echo -e "CMD='$CMD'" >> $WORK_DIR/data
  grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT" && local REMOTE="${REMOTE_PASSWORD_INPUT}${URL_SERVER_IP}:${URL_SERVER_PORT}" && echo -e "REMOTE=$REMOTE" >> $WORK_DIR/data

  mv $TEMP_DIR/nodepass $WORK_DIR/np-stb
  mv $TEMP_DIR/nodepass-core $WORK_DIR/np-dev
  mv $TEMP_DIR/qrencode $WORK_DIR/
  chmod +x $WORK_DIR/{np-stb,np-dev,qrencode}

  case "$VERSION_TYPE_CHOICE" in
    2) ln -sf "$WORK_DIR/np-dev" "$WORK_DIR/nodepass" ;;
    *) ln -sf "$WORK_DIR/np-stb" "$WORK_DIR/nodepass" ;;
  esac

  create_service

  sleep 2

  check_install
  local INSTALL_STATUS=$?

  if [ $INSTALL_STATUS -eq 0 ]; then
    create_shortcut
    get_api_key
    get_uri
    info "\n $(text 10) "

    if grep -q '.' <<< "$REMOTE_SERVER_INPUT" && grep -q '.' <<< "$REMOTE_PORT_INPUT"; then
      # Client alias, nodepass-dash requires alias when modifying instances
      local CLIENT_ALIAS="api_client"

      # Execute API request
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

}

create_service() {
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

create_shortcut() {
  local DOWNLOAD_COMMAND
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    DOWNLOAD_COMMAND="curl -ksSL"
  else
    DOWNLOAD_COMMAND="wget --no-check-certificate -qO-"
  fi

  cat > ${WORK_DIR}/np.sh << EOF
#!/usr/bin/env bash

bash <($DOWNLOAD_COMMAND https://run.nodepass.eu/np.sh) \$1
EOF
  chmod +x ${WORK_DIR}/np.sh
  ln -sf ${WORK_DIR}/np.sh /usr/bin/np
  ln -sf ${WORK_DIR}/nodepass /usr/bin/nodepass
  [ -s /usr/bin/np ] && info "\n $(text 57) "
}

uninstall() {
  if [ "$IN_CONTAINER" = 1 ] || [ "$SERVICE_MANAGE" = "none" ]; then
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

change_intranet_penetration_server() {
  reading "\n $(text 75) " REMOTE_SERVER_INPUT
  until validate_ip_address "$REMOTE_SERVER_INPUT"; do
    reading "\n $(text 75) " REMOTE_SERVER_INPUT
  done

  [[ "$REMOTE_SERVER_INPUT" =~ ^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$ ]] && REMOTE_SERVER_INPUT="[${REMOTE_SERVER_INPUT}]"

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

  # Client alias, nodepass-dash requires alias when modifying instances
  local CLIENT_ALIAS="api_client"

  # Execute API request
  if [ "$DOWNLOAD_TOOL" = "curl" ]; then
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
    wget --no-check-certificate -qO- --method=PUT \
      --header="accept: application/json" \
      --header="X-API-Key: ${KEY}" \
      --header="Content-Type: application/json" \
      --body-data="{\"url\": \"client://${REMOTE_PASSWORD_INPUT}${REMOTE_SERVER_INPUT}:${TUNNEL_PORT_INPUT}/127.0.0.1:${PORT}?min=4\", \"alias\": \"${CLIENT_ALIAS}\"}" \
      "${HTTP_S}://127.0.0.1:${PORT}/${PREFIX}/v1/instances/${INSTANCE_ID}" &>/dev/null
  fi

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

change_api_key() {
  local INSTALL_STATUS=$1
  info " $(text 65) "

  if [ "$INSTALL_STATUS" = 1 ]; then
    start_nodepass
    local NEED_STOP=1
    sleep 2
  fi

  [[ -z "$PORT" || -z "$PREFIX" ]] && get_api_url
  [ -z "$KEY" ] && get_api_key

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

  local NEW_KEY=$(sed 's/.*url":"\([^"]\+\)".*/\1/' <<< "$RESPONSE")

  if [ "${#NEW_KEY}" = 32 ]; then
    info " $(text 63) "

    get_api_url output
    info " $(text 40) $NEW_KEY"

    [ "$NEED_STOP" = 1 ] && stop_nodepass

    return 0
  else
    warning " $(text 64) "

    [ "$NEED_STOP" = 1 ] && stop_nodepass

    return 1
  fi

}

menu_setting() {
  INSTALL_STATUS=$1

  unset OPTION ACTION

  get_latest_version

  if [ "$INSTALL_STATUS" = 2 ]; then
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

    if [ $INSTALL_STATUS -eq 0 ]; then
      NODEPASS_STATUS=$(text 34)
      OPTION[1]="1. $(text 56) (np -o)"
    else
      NODEPASS_STATUS=$(text 33)
      OPTION[1]="1. $(text 58) (np -o)"
    fi

      OPTION[2]="2. $(text 62) (np -k)"
      OPTION[3]="3. $(text 30) (np -v)"
      OPTION[4]="4. $(text 95) (np -t)"
      OPTION[5]="5. $(text 29) (np -u)"
      grep -q '.' <<< "$REMOTE" && OPTION[6]="6. $(text 70) (np -c)"
      OPTION[0]="0. $(text 31)"

      ACTION[1]() { on_off $INSTALL_STATUS; exit 0; }
      ACTION[2]() { change_api_key; exit 0; }
      ACTION[3]() { upgrade_nodepass; exit 0; }
      ACTION[4]() { switch_nodepass_version; exit 0; }
      ACTION[5]() { uninstall; exit 0; }
      grep -q '.' <<< "$REMOTE" && ACTION[6]() { change_intranet_penetration_server; exit 0; }
      ACTION[0]() { exit 0; }
  fi
}

menu() {
  echo -e "\033[H\033[2J\033[3J"
  echo "
╭───────────────────────────────────────────╮
│    ░░█▀█░█▀█░░▀█░█▀▀░█▀█░█▀█░█▀▀░█▀▀░░    │
│    ░░█░█░█░█░█▀█░█▀▀░█▀▀░█▀█░▀▀█░▀▀█░░    │
│    ░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀░░    │
├───────────────────────────────────────────┤
│   >Universal TCP/UDP Tunneling Solution   │
╰───────────────────────────────────────────╯ "

  if [ -n "$STABLE_LOCAL_VERSION" ] || [ -n "$DEV_LOCAL_VERSION" ]; then
    info " $(text 45) "
  fi
  if [ -n "$STABLE_LATEST_VERSION" ] || [ -n "$DEV_LATEST_VERSION" ]; then
    info " $(text 46) "
  fi
  if [ -n "$RUNNING_LOCAL_VERSION" ]; then
    info " $VERSION_TYPE_TEXT $RUNNING_LOCAL_VERSION"
  fi
  grep -qEw '0|1' <<< "$INSTALL_STATUS" && info " $(text 60) $NODEPASS_STATUS "
  grep -q '.' <<< "$API_URL" && info " $(text 39) $API_URL"
  grep -q '.' <<< "$KEY" && info " $(text 40) $KEY"
  grep -q '.' <<< "$SERVER_CMD" && info " $(text 82) $SERVER_CMD"
  grep -q '.' <<< "$URI" && [ -x "${WORK_DIR}/qrencode" ] && info " $(text 90) $URI"
  info " Version: $SCRIPT_VERSION $(text 1) "
  echo "------------------------"

  for ((b=1;b<=${#OPTION[*]};b++)); do [ "$b" = "${#OPTION[*]}" ] && hint " ${OPTION[0]} " || hint " ${OPTION[b]} "; done

  echo "------------------------"

  reading " $(text 38) " MENU_CHOICE

  if grep -qE "^[0-9]+$" <<< "$MENU_CHOICE" && [ "$MENU_CHOICE" -ge 0 ] && [ "$MENU_CHOICE" -lt ${#OPTION[@]} ]; then
    ACTION[$MENU_CHOICE]
  else
    warning " $(text 17) [0-$((${#OPTION[@]}-1))] " && sleep 1 && menu
  fi
}

main() {
  parse_args "$@"

  OPTION="${1,,}"

  [ "${1,,}" = "-h" ] && help && exit 0

  check_root

  check_system_info

  check_system

  check_dependencies

  check_cdn

  compatibility_old_binary


  check_install
  local INSTALL_STATUS=$?

  [ "$INSTALL_STATUS" != 2 ] && select_language

  case "$1" in
    -i)
      if [ "$INSTALL_STATUS" != 2 ]; then
        warning " ${E[18]}\n ${C[18]} "
      else
        grep -q '^$' <<< "$L" && select_language
        install
      fi
      ;;
    -u)
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || uninstall
      ;;
    -v)
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || upgrade_nodepass
      ;;
    -t)
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || switch_nodepass_version
      ;;
    -o)
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || on_off $INSTALL_STATUS
      ;;
    -s)
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
      [ "$INSTALL_STATUS" = 2 ] && warning " ${E[59]}\n ${C[59]} " || change_api_key $INSTALL_STATUS
      ;;
    -c)
      if [ "$INSTALL_STATUS" != 2 ]; then
        get_api_url
        get_api_key
        change_intranet_penetration_server
      else
        warning " ${E[59]}\n ${C[59]} "
      fi
      ;;
    *)
      grep -q '^$' <<< "$L" && select_language
      menu_setting $INSTALL_STATUS
      menu
      ;;
  esac
}

main "$@"
