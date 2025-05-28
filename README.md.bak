# NodePass 部署脚本

## 项目说明

NodePass 通用TCP/UDP隧道解决方案，免配置单文件多模式，采用控制数据双路分离架构，内置零延迟自适应连接池，实现跨网络限制的快速安全访问。

本脚本提供了简单易用的 master 模式，即 API 模式的安装、配置和管理功能。

简体中文 | [English](README_EN.md)

## 目录
- [项目说明](#项目说明)
- [项目特点](#项目特点)
- [部署方法](#部署方法)
  - [交互式部署](#交互式部署)
  - [无交互式部署](#无交互式部署)
- [部署后的快捷指令](#部署后的快捷指令)
- [目录结构](#目录结构)
- [系统要求](#系统要求)
- [部署截图](#部署截图)
- [问题反馈](#问题反馈)

## 项目特点

- **多系统支持**：兼容 Debian、Ubuntu、CentOS、Fedora、Alpine、Arch 和 OpenWrt 等多种 Linux 发行版
- **双语界面**：提供中英文双语界面，满足不同用户的语言需求
- **自动检测**：自动检测系统架构、依赖和环境，确保安装过程顺利进行
- **灵活配置**：支持自定义端口、API 前缀和 TLS 加密模式
- **TLS 加密**：提供多种 TLS 加密选项，包括无加密、自签名证书和自定义证书
- **服务管理**：支持一键启动、停止和重启服务
- **自动更新**：检查并安装最新版本，保持软件始终处于最新状态
- **容器支持**：自动识别容器环境并适配相应的服务管理方式
- **快捷指令**：安装后创建快捷指令，方便日常管理

## 部署方法

### 交互式部署

1. 下载并执行脚本：

```bash
bash <(wget -qO- https://run.nodepass.eu/np.sh)
```

或

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh)
```

2. 按照界面提示选择语言（默认中文）
3. 在主菜单中选择"安装 NodePass"
4. 根据提示输入以下信息：
   - 服务器 IP（默认为 127.0.0.1）
   - 端口号（1024-65535，留空则使用 1024-8192 的随机端口）
   - API 前缀（默认为 api）
   - TLS 模式（0: 无加密, 1: 自签名证书, 2: 自定义证书）
5. 等待安装完成

### 无交互式部署

使用以下命令进行无交互式安装，可以通过命令行参数指定配置：

<details>
    <summary> 示例1：使用中文，指定服务器IP、端口、API前缀和无TLS加密（点击即可展开或收起）</summary>
<br>

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

<details>
    <summary> 示例2：使用英文，指定服务器IP、端口、API前缀和自签名证书（点击即可展开或收起）</summary>
<br>

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

<details>
    <summary> 示例3：使用中文，指定服务器IP、端口、API前缀、自定义证书及证书文件路径（点击即可展开或收起）</summary>
<br>

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 1.2.3.4 \
  --user_port 18080 \
  --prefix api \
  --tls_mode 2 \
  --cert_file /tmp/cert.pem \
  --key_file /tmp/key.pem
```
</details>

如果不指定参数，将使用默认配置：
- 服务器 IP: 127.0.0.1
- 端口: 1024-8192 随机端口
- API 前缀: api
- TLS 模式: 无加密

## 部署后的快捷指令

安装完成后，系统会创建 `np` 快捷指令，可以通过以下方式使用：

- `np` - 显示菜单
- `np -i` - 安装 NodePass
- `np -u` - 卸载 NodePass
- `np -v` - 升级 NodePass
- `np -o` - 切换服务状态（开启/停止）
- `np -k` - 更换 NodePass API key
- `np -s` - 显示 NodePass API 信息
- `np -h` - 显示帮助信息

## 目录结构

```
/etc/nodepass/
├── data                # 配置数据文件
├── nodepass            # 主程序
├── nodepass.gob        # 数据存储文件
└── np.sh               # 部署和管理脚本
```

## 系统要求

- 操作系统：支持 Debian、Ubuntu、CentOS、Fedora、Alpine、Arch 和 OpenWRT 等 Linux 发行版
- 架构：支持 x86_64 (amd64)、aarch64 (arm64) 和 armv7l (arm)
- 权限：需要 root 权限运行脚本

## 部署截图

![Image](https://github.com/user-attachments/assets/4453fde6-d64a-4557-b938-13a1affcd81f)

## 问题反馈

如遇到问题，请前往 [GitHub Issues](https://github.com/NodePassProject/npsh/issues) 提交反馈。
