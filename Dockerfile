FROM docker.1ms.run/infrastlabs/remote-desktop:gnome

# 避免交互阻塞
# ENV DEBIAN_FRONTEND=noninteractive
# ENV NODE_ENV=production

RUN apt update -y && apt upgrade -y && apt autoremove -y

# 安装必要的依赖包和软件
RUN apt-get update && \
    apt-get install -y wget ca-certificates libxss1 libxtst-dev imagemagick curl gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装Node.js官方仓库并安装nodejs和npm
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g nrm && \
    nrm use taobao && \
    npm install -g midscene-pc@latest && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 复制软件包到容器并批量安装
COPY software/ /tmp/software/
RUN apt-get update && \
    for deb in /tmp/software/*.deb; do \
    echo "Installing $(basename $deb)..."; \
    dpkg -i "$deb" || true; \
    done && \
    apt-get install -yf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/software/

# 安装gnome-terminal并配置为默认终端
RUN apt-get update && \
    apt-get install -y gnome-terminal && \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/gnome-terminal 50 && \
    update-alternatives --set x-terminal-emulator /usr/bin/gnome-terminal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 复制supervisor配置文件
COPY src/midscene-pc.conf /etc/supervisor/conf.d/
