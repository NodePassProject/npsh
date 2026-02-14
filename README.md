# NodePass Deployment and Management Guide

`np.sh`: One-click deployment of the NodePass main program, providing high-performance TCP/UDP tunneling with multi-system support and flexible configuration.
`dash.sh`: One-click deployment of the NodePassDash control panel, simplifying tunnel management and monitoring with containerization and HTTPS support.

- Stable: v1.15.0
- Development: v2.0.0-b1

---

## Table of Contents

- [Introduction](#introduction)
- [System Requirements](#system-requirements)
- [1. `np.sh` Script (Main Program Installation)](#1-npsh-script-main-program-installation)
  - [Features](#features)
  - [Deployment Methods](#deployment-methods)
    - [Interactive Deployment](#interactive-deployment)
    - [Non-interactive Deployment](#non-interactive-deployment)
  - [Quick Commands](#quick-commands)
  - [Directory Structure](#directory-structure)
- [2. `dash.sh` Script (Control Panel Installation)](#2-dashsh-script-control-panel-installation)
  - [Features](#features-1)
  - [Usage Instructions](#usage-instructions)
  - [Uninstallation Instructions](#uninstallation-instructions)
  - [Update Version](#update-version)
  - [Reset Password](#reset-password)
- [Feedback](#feedback)
- [Deployment Screenshots](#deployment-screenshots)

---

## Introduction

**NodePass** is a universal TCP/UDP tunneling solution with a control-data separation architecture, supporting zero-latency connection pools and multi-mode communication for high-performance, secure access across network restrictions.

---

## System Requirements

- **Operating System**: Compatible with Debian, Ubuntu, CentOS, Fedora, Alpine, Arch, OpenWRT, and more
- **Architecture**: Supports x86_64 (amd64), aarch64 (arm64), armv7l (arm)
- **Permissions**: Requires root privileges to run

---

## 1. `np.sh` Script (Main Program Installation)

### Features

- Multi-system support
- Automatic detection of architecture and dependencies
- Flexible configuration of ports, API prefixes, and TLS modes
- Supports no encryption, self-signed certificates, or custom certificates
- One-click service start, stop, restart, and uninstall
- Automatic updates to the latest version
- Automatic recognition of container environments
- Supports installation of stable and development versions

---

### Deployment Methods

#### Interactive Deployment

```
bash <(wget -qO- https://run.nodepass.eu/np.sh)
```
or
```
bash <(curl -sSL https://run.nodepass.eu/np.sh)
```

Follow the prompts to provide the following information:

- Language selection (default: Chinese)
- Server IP (If it is 127.0.0.1, you can choose to create an instance with an intranet penetration API.)
- Port (leave blank for auto-assigned port in the 1024–8192 range)
- API prefix (default: `api`)
- TLS mode (0: no encryption, 1: self-signed certificate, 2: custom certificate)

---

#### Non-interactive Deployment

<details>
    <summary>Example 1: No TLS encryption</summary>

```
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 127.0.0.1 \
  --user_port 18080 \
  --version stable \
  --prefix api \
  --tls_mode 0
```

</details>

<details>
    <summary>Example 2: Self-signed certificate</summary>

```
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language en \
  --server_ip localhost \
  --user_port 18080 \
  --version dev \
  --prefix api \
  --tls_mode 1
```

</details>

<details>
    <summary>Example 3: Custom certificate</summary>

```
bash <(curl -sSL https://run.nodepass.eu/np.sh) \
  -i \
  --language zh \
  --server_ip 1.2.3.4 \
  --user_port 18080 \
  --version stable \
  --prefix api \
  --tls_mode 2 \
  --cert_file </path/to/cert.pem> \
  --key_file </path/to/key.pem>
```

</details>

---

### Quick Commands

After installation, the `np` shortcut command is created:

| Command   | Description                          |
|-----------|--------------------------------------|
| `np`      | Display interactive menu             |
| `np -i`   | Install NodePass                     |
| `np -u`   | Uninstall NodePass                   |
| `np -v`   | Upgrade NodePass                     |
| `np -t`   | Switch between stable and dev        |
| `np -o`   | Start/stop service                   |
| `np -k`   | Change API key                       |
| `np -s`   | View API information                 |
| `np -h`   | Display help information             |

---

### Directory Structure

```
/etc/nodepass/
├── data                # Configuration data
├── nodepass            # Main program symlink pointing to the currently used kernel file
├── np-dev              # Development version kernel file
├── np-stb              # Stable version kernel file
├── nodepass.gob        # Data storage file
└── np.sh               # Deployment script
```

---

## 2. `dash.sh` Script (Control Panel Installation)

### Features

- One-click deployment of NodePassDash control panel
- Supports Debian, Ubuntu, CentOS
- Automatic detection of system and dependencies
- Host network mode is used, enabling seamless integration with host APIs
- Supports Docker and Podman for container deployment
- Automatic reverse proxy configuration (with HTTPS support)
- Automatic CA SSL certificate issuance (for domain-based deployment)
- Automatic mounting of logs and public resource directories

---

### Usage Instructions

1. **Run the script**:

```
bash <(wget -qO- https://run.nodepass.eu/dash.sh)
```
or
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh)
```

2. **Provide information**:

- Domain or IP: Entering a domain enables HTTPS reverse proxy and SSL certificate issuance; entering an IP skips reverse proxy and Caddy installation.
- Port: Default is 3000, customizable.

3. **Container deployment**:

- Automatically uses Docker or Podman to run the control panel container
- Checks for port conflicts

4. **Mounted directories**:

| Host Path                   | Container Path      | Purpose       |
|-----------------------------|---------------------|---------------|
| `~/nodepassdash/logs`       | `/app/logs`         | Log files     |
| `~/nodepassdash/db`         | `/app/db`           | Database      |

5. **Completion prompt**: The script will output the access address and admin account details upon completion.

### Uninstallation Instructions

To uninstall the NodePassDash control panel:

```
bash <(wget -qO- https://run.nodepass.eu/dash.sh) uninstall
```
or
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh) uninstall
```

This will clean up the container, configuration files, and mounted directories.

### Update Version

Update the NodePassDash container:

```
bash <(wget -qO- https://run.nodepass.eu/dash.sh) update
```
or
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh) update
```

This will update based on the local and remote versions.

### Reset Password

```
bash <(wget -qO- https://run.nodepass.eu/dash.sh) resetpwd
```
or
```
bash <(curl -sSL https://run.nodepass.eu/dash.sh) resetpwd
```

## Feedback

For installation or usage issues, please submit feedback at [GitHub Issues](https://github.com/NodePassProject/npsh/issues).