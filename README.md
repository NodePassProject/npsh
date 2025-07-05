# 📘 NodePass 安装与管理说明文档

简体中文 | [English](README_EN.md)

`np.sh`: 一键部署 NodePass 主程序，提供高性能 TCP/UDP 隧道服务，支持多系统和灵活配置。

`dash.sh`: 一键部署 NodePassDash 控制面板，简化隧道管理和监控，支持容器化和 HTTPS 配置。

---

## 📑 目录

* [项目介绍](#项目介绍)
* [系统要求](#系统要求)
* [一、np.sh 脚本（主程序安装）](#一npsh-脚本主程序安装)

  * [功能特色](#功能特色)
  * [部署方法](#部署方法)

    * [交互式部署](#交互式部署)
    * [无交互式部署](#无交互式部署)
  * [部署后的快捷指令](#部署后的快捷指令)
  * [目录结构](#目录结构)
* [二、dash.sh 脚本（控制面板安装）](#二dashsh-脚本控制面板安装)

  * [功能特色](#功能特色-1)
  * [使用说明](#使用说明)
  * [卸载说明](#卸载说明)
  * [更新版本](#更新版本)
  * [重置密码](#重置密码)
* [部署截图](#部署截图)
* [常见问题与反馈](#常见问题与反馈)

---

## 项目介绍

**NodePass** 是一款通用 TCP/UDP 隧道解决方案，采用控制数据双路分离架构，支持零延迟连接池与多模式通信，致力于实现高性能、跨网络限制的安全访问。

---

## 系统要求

* **操作系统**：兼容 Debian、Ubuntu、CentOS、Fedora、Alpine、Arch、OpenWRT 等
* **系统架构**：支持 x86\_64（amd64）、aarch64（arm64）、armv7l（arm）
* **权限要求**：需要 root 权限运行

---

## 一、`np.sh` 脚本（主程序安装）

### 功能特色

* ✅ 多系统支持
* 🌐 支持中英文界面
* 🔍 自动检测架构与依赖
* 🔧 灵活配置端口、API 前缀、TLS 模式
* 🔐 支持无加密、自签名或自定义证书
* 🛠️ 支持服务一键启动、停止、重启、卸载
* 🔄 自动更新保持最新版本
* 🐳 自动识别容器环境

---

### 部署方法

#### 交互式部署

```bash
bash <(wget -qO- https://run.nodepass.eu/np.sh)
```
或
```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh)
```

跟随提示操作，依次填写以下信息：

* 语言选择（默认中文）
* 服务器 IP（如是 127.0.0.1，则可选择创建内网穿透 API 的实例）
* 端口（可留空，系统将自动分配 1024–8192 范围内端口）
* API 前缀（默认 `api`）
* TLS 模式（0: 无加密, 1: 自签名证书, 2: 自定义证书）

---

#### 无交互式部署

<details><summary>示例1：无TLS加密</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 127.0.0.1 \
  --user_port 18080 \
  --prefix api \
  --tls_mode 0
```

</details>

<details><summary>示例2：自签名证书</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language en \
  --server_ip localhost \
  --user_port 18080 \
  --prefix api \
  --tls_mode 1
```

</details>

<details><summary>示例3：自定义证书</summary>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 1.2.3.4 \
  --user_port 18080 \
  --prefix api \
  --tls_mode 2 \
  --cert_file </path/to/cert.pem> \
  --key_file </path/to/key.pem>
```

</details>

---

### 部署后的快捷指令

系统将创建 `np` 快捷命令：

| 命令      | 功能说明        |
| ------- | ----------- |
| `np`    | 显示交互式菜单     |
| `np -i` | 安装 NodePass |
| `np -u` | 卸载 NodePass |
| `np -v` | 升级 NodePass |
| `np -o` | 启动/停止服务   |
| `np -k` | 更换 API key  |
| `np -k` | 更换 API 内网穿透的服务器 |
| `np -s` | 查看 API 信息   |
| `np -h` | 显示帮助信息     |

---

### 目录结构

```
/etc/nodepass/
├── data                # 配置数据
├── nodepass            # 主程序
├── nodepass.gob        # 数据存储文件
└── np.sh               # 部署脚本
```

---

## 二、`dash.sh` 脚本（控制面板安装）

### 功能特色

* 🚀 一键部署 NodePassDash 控制面板
* 🐧 支持 Debian、Ubuntu、CentOS
* 🔧 自动检测系统和依赖环境
* 🐳 支持 Docker 和 Podman 部署容器
* 🔄 自动配置反向代理（支持 HTTPS）
* 🔐 自动申请 CA SSL 证书（域名部署时）
* 📂 自动挂载日志与公共资源目录

---

### 使用说明

1. **运行脚本**：

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) install
```
或
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh) install
```

2. **输入信息**：

* 域名或 IP：输入域名会自动配置 HTTPS 反向代理并申请 SSL；输入 IP 则跳过反向代理与 Caddy 安装。
* 端口：默认 3000，可自定义。

3. **部署容器**：

* 自动使用 Docker 或 Podman 运行面板容器
* 检查端口是否占用

4. **挂载目录**：

| 主机路径                    | 容器内路径         | 用途   |
| ----------------------- | ------------- | ---- |
| `~/nodepassdash/logs`   | `/app/logs`   | 日志文件 |
| `~/nodepassdash/public` | `/app/public` | 公共资源 |

5. **完成提示**：脚本安装完毕后会输出访问地址和管理员账户信息。

### 卸载说明

卸载 NodePassDash 控制面板：

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) uninstall
```
或
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh) uninstall
```

将会清理容器、配置文件与挂载目录。

### 更新版本

更新 NodePassDash 容器：

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) update
```
或
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh) update
```

将根据本地和远程版本更新。

### 重置密码

```bash
bash <(wget -qO- https://run.nodepass.eu/dash.sh) resetpwd
```
或
```bash
bash <(curl -sSL https://run.nodepass.eu/dash.sh) resetpwd
```

---

## 部署截图

<img width="690" alt="image" src="https://github.com/user-attachments/assets/4453fde6-d64a-4557-b938-13a1affcd81f" />

<img width="690" alt="image" src="https://github.com/user-attachments/assets/61e01872-f401-485d-aa9a-8c1388e76a5b" />

---

## 常见问题与反馈

如遇到安装或使用问题，请前往 GitHub 提交 Issues：

👉 [NodePass GitHub Issues](https://github.com/NodePassProject/npsh/issues)