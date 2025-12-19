#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
show_menu() {
    clear
    # 显示菜单
    # echo -e "${GREEN}================================${NC}"
    # echo -e "${GREEN}       系统管理脚本             ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${NC}1. 安装/更新${NC}"
    echo -e "${NC}2. 卸载${NC}"
    echo -e "${YELLOW}0. 返回${NC}"
    echo -e "${GREEN}================================${NC}"
}
goinstall(){
    VERSION=$(curl -s http://go.mekill.top/dl/?mode=json | grep -m1 version | cut -d'"' -f4)
    if which wget >/dev/null 2>&1; then
        wget "https://go.mekill.top//dl/$VERSION.linux-amd64.tar.gz" -O go.linux-amd64.tar.gz
        
    else
        curl -L "https://go.mekill.top//dl/$VERSION.linux-amd64.tar.gz" -o go.linux-amd64.tar.gz
    fi
    rm -rf /usr/local/go && tar -C /usr/local -xzf go.linux-amd64.tar.gz
    # 检查 /usr/local/go/bin 是否已在 PATH 中
    local profile="/etc/profile"
    if ! grep -q "/usr/local/go/bin" "$profile"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
        echo "已添加 PATH"
    else
        echo "PATH 已存在，无需添加"
    fi
        # 检查并添加 GO111MODULE
    if ! grep -q "GO111MODULE=on" "$profile"; then
        echo 'export GO111MODULE=on' | sudo tee -a "$profile"
        echo "✓ 系统级添加 GO111MODULE=on"
    fi
    
    # 检查并添加 GOPROXY
    if ! grep -q "GOPROXY=https://goproxy.cn,direct" "$profile"; then
        echo 'export GOPROXY=https://goproxy.cn,direct' | sudo tee -a "$profile"
        echo "✓ 系统级添加 GOPROXY=https://goproxy.cn,direct"
    fi
    source "$profile" 2>/dev/null || true
    rm go.linux-amd64.tar.gz
}

gouninstall(){
    rm -rf /usr/local/go
    # 方法2: 更精确的删除
    sed -i '/export PATH=\$PATH:\/usr\/local\/go\/bin/d' /etc/profile
    # 删除 GO111MODULE
    sudo sed -i '/export GO111MODULE=on/d' /etc/profile

    # 删除 GOPROXY
    sudo sed -i '/export GOPROXY=https:\/\/goproxy.cn,direct/d' /etc/profile
    source "$profile" 2>/dev/null || true
}


while true; do
    show_menu
    read -p "请选择: " choice
    case $choice in
        1)
            goinstall
            echo "golang已安装，重启终端生效"
            echo "或者运行：source /etc/profile"
            ;;
        2)
            gouninstall
            echo "golang文件已删除"
            echo "golang已卸载，重启终端生效"
            echo "或者运行：source /etc/profile"
            ;;
        0)
            break
            ;;
    esac
    read -s -p "按回车键返回..." </dev/tty
done




