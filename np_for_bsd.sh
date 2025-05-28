#!/usr/bin/env sh
# NodePass Installer for BSD v0.4.0

# defaults
LANG=zh; IP=127.0.0.1; PORT=0; PREFIX=api; TLS=0; CRT=; KEY=;
REPO=NodePassProject/NodePass; API=https://api.github.com/repos/$REPO/releases/latest
WORK=/etc/nodepass; BIN=/usr/local/bin/nodepass; SCRIPTS=/usr/local/bin/np; RC=/usr/local/etc/rc.d/nodepass

# detect
ARCH=$(uname -m|sed s/x86_64/amd64/); OS=$(uname|tr A-Z a-z)
if grep -qE '/docker|/lxc' /proc/1/cgroup 2>/dev/null; then CONT=1; else CONT=0; fi

# msg
t(){ [ "$LANG" = zh ]&& printf "%s\n" "$2"||printf "%s\n" "$1"; }
err(){ t "$1" "$2" >&2; exit 1; }

# deps
for c in sh curl tar sysrc service openssl;do command -v $c||err "Missing $c" "缺少 $c";done

# GET latest tag
ver=$(curl -s $API|grep -Po '"tag_name": "v?[0-9.]+"'|head -1|cut -d '"' -f4)||err "Fetch fail" "获取失败"

# URL
url=https://github.com/$REPO/releases/download/$ver/nodepass_${ver#v}_$OS_$ARCH.tar.gz

# install
_do_install(){
  curl -sL $url|tar xz -C /tmp
  install -m755 /tmp/nodepass $BIN||err "Install fail" "安装失败"
  mkdir -p $WORK
  case $TLS in 1) A="--tls --tls-self";;2) A="--tls --tls-cert $CRT --tls-key $KEY";;*)A="";;esac
  cat> $RC<<EOF
#!/bin/sh
. /etc/rc.subr
name=nodepass;rcvar=nodepass_enable;command=$BIN;pidfile=/var/run/nodepass.pid
start_cmd="nodepass_start";stop_cmd="nodepass_stop"
nodepass_start(){\$command --dir $WORK --host $IP --port $PORT --prefix $PREFIX $A>>/var/log/nodepass.log 2>&1 &echo \$!>/var/run/nodepass.pid}
nodepass_stop(){kill \$(cat /var/run/nodepass.pid)}
load_rc_config \$name;nodepass_enable=YES;run_rc_command "$1"
EOF
  chmod +x $RC;service nodepass start;ln -sf /etc/nodepass/np_for_bsd.sh $SCRIPTS
  t "Installed $ver" "已安装 $ver"
}

# uninstall
_do_uninstall(){ service nodepass stop;sysrc -x nodepass_enable;rm -f $BIN $RC $SCRIPTS;rm -rf $WORK /var/run/nodepass.pid; t "Uninstalled" "已卸载"; }

do_toggle(){service nodepass onestatus&&service nodepass stop||service nodepass start}
do_restart(){service nodepass restart}
do_upgrade(){_do_uninstall;_do_install}
do_key(){f=$WORK/config.json;[ -f $f ]||err "Not installed" "未安装";k=$(openssl rand -hex 16);sed -i '' -E "s/\"api_key\": \"[0-9a-f]+\"/\"api_key\": \"$k\"/" $f;t "New key $k" "新密钥 $k"}
do_info(){f=$WORK/config.json;[ -f $f ]||err "Not installed" "未安装";grep -E 'url|key' $f;}
# args
while [ "$1" ];do case $1 in
  -i|--install)CMD=install;;-u)CMD=uninstall;;-o)CMD=toggle;;-r)CMD=restart;;-v)CMD=upgrade;;-k)CMD=key;;-s)CMD=info;;
  --lang)LANG=$2;shift;;--ip)IP=$2;shift;;--port)PORT=$2;shift;;--prefix)PREFIX=$2;shift;;
  --tls)TLS=$2;shift;;--crt)CRT=$2;shift;;--key)KEY=$2;shift;;-h)CMD=help;;esac;shift;done
# help
_do_help(){cat<<EOF
$(t "Usage: np_for_bsd.sh [opts] cmd" "用法: np_for_bsd.sh [选项] 命令")
 cmds: install(-i) uninstall(-u) toggle(-o) restart(-r) upgrade(-v) key(-k) info(-s)
 opts: --lang zh|en --ip IP --port P --prefix PF --tls 0|1|2 --crt file --key file
EOF
exit}
[ -z "$CMD" ]&&_do_install||case $CMD in
  install)_do_install;;uninstall)_do_uninstall;;toggle)do_toggle;;restart)do_restart;;upgrade)do_upgrade;;key)do_key;;info)do_info;;help)_do_help;;esac
