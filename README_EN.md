<div align="center">

# 🐳 Midscene PC Docker Container

**Ubuntu GNOME desktop-based Docker container with pre-installed Midscene PC service, supporting VNC remote access to the graphical interface**

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![VNC](https://img.shields.io/badge/VNC-4A90E2?style=for-the-badge&logo=vnc&logoColor=white)](https://www.realvnc.com/)

[📖 Original Project](https://github.com/infrastlabs/docker-remote-desktop) | [📚 Midscene PC Service Documentation](https://github.com/mofangbao/midscene-pc)

</div>

---

## 📖 Project Overview

This project is based on the original project and pre-installs the following components:
- 🌐 **Chrome Browser**
- 🖥️ **Terminal with right-click support in folders**
- 🤖 **Midscene PC Automation Service**

<div align="center">

![System Preview](./src/screenshots/main.jpg)

</div>

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🖥️ **Ubuntu GNOME Desktop Environment** | Complete graphical interface experience |
| 🚀 **Midscene PC Auto-start** | Automatically runs using supervisor process manager |
| 🌐 **VNC Remote Access** | Access via browser or VNC client |
| 🔍 **Chrome Browser** | Pre-installed Google Chrome browser |
| ⚡ **Node.js Environment** | Supports running JavaScript applications |

---

## 🚀 Quick Start

### 📥 Get Image

<details>
<summary><b>🔨 Build Yourself</b></summary>

```bash
git clone https://github.com/mofangbao/midscene-pc-docker.git
cd midscene-pc-docker
docker build -t ppagent/midscene-ubuntu-desktop:latest .
```

</details>

<details>
<summary><b>📦 Pull from Docker Hub</b></summary>

```bash
docker pull ppagent/midscene-ubuntu-desktop:latest
```

</details>

### 🏃‍♂️ Run Container

#### Using Startup Script (Recommended)

```bash
# Use the provided startup script
./start.sh
```

#### Manual Docker Run

```bash
# Or run manually
docker run -d \
  --name midscene-desktop \
  -p 10081:10081 \
  -p 3333:3333 \
  -v $(pwd)/data:/mnt/data \
  midscene-ubuntu-desktop:latest
```

#### Docker Compose Currently Not Supported

> ⚠️ **Note**: Docker Compose is currently not supported

---

## 🔧 Auto-start Mechanism

### 📋 Supervisor Process Management
- **Configuration File**: `/etc/supervisor/conf.d/midscene-pc.conf`
- **Start Command**: Directly runs `npx midscene-pc`
- **Process Management**: Auto-start, restart, and monitoring

### 🔄 Startup Process
1. **Container starts** → GNOME desktop and supervisor load
2. **Supervisor starts** → Directly runs `npx midscene-pc`
3. **Service runs** → Executes in `/home/headless` directory

---

## 🛠️ Service Management

### 📊 Check Service Status

```bash
# Enter container
docker exec -it midscene-desktop bash

# Check supervisor status
supervisorctl status

# Check processes
ps aux | grep midscene

# View logs
tail -f /var/log/midscene-pc.log
tail -f /var/log/midscene-pc-error.log
```

### 🎛️ Manual Start/Stop

```bash
# Manage via supervisor
supervisorctl start midscene-pc
supervisorctl stop midscene-pc
supervisorctl restart midscene-pc

# Run command manually
cd /home/headless && npx midscene-pc
```

### 🆙 Midscene-pc Service Update

```bash
# Update to the latest version inside the container (temporary update)
npx midscene-pc@latest

# Restart the service after updating
supervisorctl restart midscene-pc
```

> [!IMPORTANT]
> ♻️ Permanent updates require rebuilding the image.

> [!IMPORTANT]
> 🕐 **Startup Notice**: After startup, it takes about 10 seconds to initialize the desktop. If the VNC connection shows a black screen, please wait a moment.

---

## 🌐 Port Configuration

| Port | Service | Access URL |
|------|---------|------------|
| **10081** | VNC Web Interface | http://localhost:10081 |
| **3333** | Midscene PC Service Port | - |

---

## ❓ Frequently Asked Questions

<details>
<summary><b>🔧 How to Pre-install Other Software?</b></summary>

> Copy the required deb files to the `software` directory, then rebuild the image to achieve pre-installation.
> 
> 📋 **Tested Software**: WeChat, DingTalk, VSCode, WPS and other common software all run normally.

</details>

<details>
<summary><b>🔐 What is the VNC Password?</b></summary>

If no password-related environment variables are specified in `start.sh` or your own `docker run` script, the default password is `headless`.

**Modifiable Environment Variables**:
- `VNC_PASS`
- `VNC_PASS_RO`
- `SSH_PASS`

**Default start.sh Startup Configuration**:
```bash
SSH_PASS=midscene-pc
VNC_PASS=midscene-pc
VNC_PASS_RO=midscene_pc
```

</details>

<details>
<summary><b>📱 Where are the Desktop Applications?</b></summary>

1. Click the **`Activities`** button in the top left corner
2. After the favorites bar appears, click the menu button in the favorites bar
3. The application dashboard will be displayed

<div align="center">

![Application Dashboard](./src/screenshots/dashboard.jpg)

</div>

</details>

---

## 📝 Important Notes

- **Direct Startup**: Midscene PC starts directly via supervisor without additional scripts
- **Service Logs**: Saved in `/var/log/midscene-pc.log` and `/var/log/midscene-pc-error.log`
- **Auto-restart**: Supervisor provides auto-restart functionality, automatically restarting when service exits abnormally
- **Service Directory**: Service runs in `/home/headless` directory as `headless` user
- **Management**: Use `supervisorctl` commands for convenient service status management

---

## ⚠️ Known Issues

| Platform | Issue Description | Impact Scope |
|----------|-------------------|--------------|
| 🍎 **macOS** | Manual drawing functionality not supported when creating midscene-pc devices | Fullscreen and fixed area work normally |
| 🍎 **macOS** | VNC connection cannot automatically adapt to Retina display | Does not affect actual automation operations |
| 🐳 **Docker** | Currently only supports docker run startup | Docker Compose not supported |
| 💾 **Data Persistence** | Full data persistence is not supported; you can mount external directories into the container | Use `-v` to mount a host directory to preserve data |

---

<div align="center">

**🎉 Thank you for using Midscene PC Docker Container!**

If you have any questions or suggestions, feel free to submit an [Issue](https://github.com/mofangbao/midscene-pc-docker/issues) or [Pull Request](https://github.com/mofangbao/midscene-pc-docker/pulls)

</div>