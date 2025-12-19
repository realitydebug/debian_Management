#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
show_menu() {
    clear
    if which git &> /dev/null; then
        echo "Git 已安装"
    else
        echo "Git 未安装"
    fi
    # 显示菜单
    echo -e "${GREEN}================================${NC}"
    echo -e "${NC}1. 安装/更新${NC}"
    echo -e "${NC}2. 配置用户信息${NC}"
    echo -e "${NC}3. 查看配置${NC}"
    echo -e "${NC}3. 卸载${NC}"
    echo -e "${YELLOW}0. 返回${NC}"
    echo -e "${GREEN}================================${NC}"
}
while true; do
    show_menu
    read -p "请选择: " choice
    case $choice in
        1)
            apt update
            apt install git
            echo "已执行安装"
            ;;
        2)
            read -p "使用默认(y?): " ans
            if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
                git config --global user.name "admin"
                git config --global user.email "admin@outlook.com"
            else
                read -p "用户名: " name
                git config --global user.name "$name"
                read -p "邮箱: " email
                git config --global user.email "$email"
            fi
            echo "配置完成"
            ;;
        3)
            git config --list
            ;;
        4)
            apt purge git
            apt autoremove
            echo "已执行卸载"
            ;;
        0)
            break
            ;;
   esac
    read -s -p "按回车键返回..." </dev/tty
    break
done


