#!/bin/bash
clear

if which docker >/dev/null 2>&1; then
    echo "Docker已安装"
    docker --version
    echo "正在检测最新版..."
    apt update -y >/dev/null 2>&1
    echo "最新版本号为："
    docker version --format '{{.Server.Version}}' 2>/dev/null | sed 's/[^0-9.]*\([0-9.]*\).*/\1/'
    echo "最新和已安装版本号一样可忽略"
    read -p "是否更新 (y?): " ans
    if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then  # ${ans,,} 将输入转为小写
        echo "开始更新"
        apt upgrade -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        echo "更新完成，当前版本："
        docker --version
        
    fi
else
    echo "Docker未安装"
    read -p "是否安装 (y?): " ans
    if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
        echo "开始安装"

        echo "1. 卸载旧版本残留..."
        apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
        
        echo "3. 安装依赖..."
        apt install -y ca-certificates curl gnupg lsb-release

        echo "4. 创建密钥目录..."
        install -m 0755 -d /etc/apt/keyrings
        
        echo "5. 下载并添加 GPG 密钥..."
        curl -fsSL https://ddocker.mekill.top/linux/debian/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
    
        echo "6. 添加 Docker 仓库..."
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://ddocker.mekill.top/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

        echo "7. 更新包列表..."
        apt update -y

        echo "8. 安装 Docker..."
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        echo "9. 验证安装..."
        docker --version

    fi
fi

read -s -p "按任意键返回..." </dev/tty