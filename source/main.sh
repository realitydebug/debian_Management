#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
show_menu() {
    clear
    codename=$(lsb_release -cs)
    echo "系统代号: $codename"
    # 显示菜单
    # echo -e "${GREEN}================================${NC}"
    # echo -e "${GREEN}       系统管理脚本             ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${NC}1. 阿里云 (mirrors.aliyun.com)${NC}"
    echo -e "${NC}2. 腾讯云 (mirrors.cloud.tencent.com)${NC}"
    echo -e "${NC}3. 中科大 (mirrors.ustc.edu.cn)${NC}"
    echo -e "${NC}4. 官方源 (deb.debian.org)${NC}"
    echo -e "${YELLOW}0. 返回${NC}"
    echo -e "${GREEN}================================${NC}"
}
while true; do
    show_menu
    read -p "请选择: " choice
    echo "$choice"
    case $choice in
        1)
           chmod +x ./source/阿里云.sh
           ./source/阿里云.sh
            ;;
        2)
            chmod +x ./source/腾讯云.sh
           ./source/腾讯云.sh
            ;;
        3)
            chmod +x ./source/中科大.sh
           ./source/中科大.sh
            ;;
        4)
            chmod +x ./source/官方.sh
           ./source/官方.sh
            ;;
        0)
            break
            ;;
    esac
done