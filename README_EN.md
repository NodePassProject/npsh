# NodePass Deployment Script

## Introduction

NodePass is a secure, efficient TCP/UDP tunneling solution that delivers fast, reliable access across network restrictions using pre-established TLS/TCP connections.

This script provides easy-to-use master mode (API mode) installation, configuration, and management functions.

[简体中文](README.md) | English

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Deployment Methods](#deployment-methods)
  - [Interactive Deployment](#interactive-deployment)
  - [Non-interactive Deployment](#non-interactive-deployment)
- [Quick Commands](#quick-commands)
- [Directory Structure](#directory-structure)
- [System Requirements](#system-requirements)
- [Deployment Screenshots](#deployment-screenshots)
- [Feedback](#feedback)

## Features

- **Multi-System Support**: Compatible with various Linux distributions including Debian, Ubuntu, CentOS, Fedora, Alpine, Arch, and OpenWRT
- **Bilingual Interface**: Provides both Chinese and English interfaces to meet different language preferences
- **Automatic Detection**: Auto-detects system architecture, dependencies, and environment to ensure smooth installation
- **Flexible Configuration**: Supports custom ports, API prefixes, and TLS encryption modes
- **TLS Encryption**: Offers multiple TLS encryption options including no encryption, self-signed certificates, and custom certificates
- **Service Management**: Supports one-click start, stop, and restart services
- **Auto Updates**: Checks and installs the latest version to keep software up-to-date
- **Container Support**: Automatically identifies container environments and adapts service management accordingly
- **Quick Commands**: Creates shortcuts after installation for convenient management

## Deployment Methods

### Interactive Deployment

1. Download and execute the script:

```bash
bash <(wget -qO- https://run.nodepass.eu/np.sh)
```

or

```bash
bash <(curl -sSL https://run.nodepass.eu/np.sh)
```

2. Follow the prompts to select language (default is Chinese)
3. Choose "Install NodePass" from the main menu
4. Enter the following information as prompted:
   - Server IP (default is 127.0.0.1)
   - Port number (1024-65535, leave empty for random port between 1024-8192)
   - API prefix (default is api)
   - TLS mode (0: no encryption, 1: self-signed certificate, 2: custom certificate)
5. Wait for installation to complete

### Non-interactive Deployment

Use the following commands for non-interactive installation with command-line parameters:

<details>
    <summary> Example 1: Chinese, specify server IP, port, API prefix, and no TLS encryption（Click to expand or collapse）</summary>
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
    <summary> Example 2: English, specify server IP, port, API prefix, and self-signed certificate（Click to expand or collapse）</summary>
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
    <summary> Example 3: Chinese, specify server IP, port, API prefix, custom certificate and certificate file paths（Click to expand or collapse）</summary>
<br>

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

If parameters are not specified, default configuration will be used:
- Server IP: 127.0.0.1
- Port: 1024-8192 random port
- API prefix: api
- TLS mode: No encryption

## Quick Commands

After installation, the system creates `np` shortcuts that can be used as follows:

- `np` - Display menu
- `np -i` - Install NodePass
- `np -u` - Uninstall NodePass
- `np -v` - Upgrade NodePass
- `np -o` - Toggle service status (start/stop)
- `np -k` - Change NodePass API key
- `np -s` - Show NodePass API information
- `np -h` - Show help information

## Directory Structure

```
/etc/nodepass/ 
├── data                # Configuration data file 
├── nodepass            # Main program 
├── nodepass.gob        # Data storage file 
└── np.sh               # Deployment and management script
```

## System Requirements

- Operating System: Supports Linux distributions including Debian, Ubuntu, CentOS, Fedora, Alpine, Arch, and OpenWRT
- Architecture: Supports x86_64 (amd64), aarch64 (arm64), and armv7l (arm)
- Permissions: Requires root privileges to run the script

## Deployment Screenshots

![Image](https://github.com/user-attachments/assets/893a3856-ec69-488f-bb99-5df26b4fb4e7)

## Feedback

If you encounter any issues, please submit feedback at [GitHub Issues](https://github.com/NodePassProject/npsh/issues).