#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
# 显示菜单
show_menu() {
    clear
    # echo -e "${GREEN}================================${NC}"
    # echo -e "${GREEN}       系统管理脚本             ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${BLUE}1. 换源管理${NC}"
    echo -e "${BLUE}2. Docker 管理${NC}"
    echo -e "${BLUE}3. SSH 配置管理${NC}"
    echo -e "${BLUE}4. Golang 管理${NC}"
    echo -e "${BLUE}5. git 管理${NC}"
    echo -e "${YELLOW}0. 退出${NC}"
    echo -e "${GREEN}================================${NC}"
}
while true; do
    show_menu
    read -p "请选择: " choice
    echo "$choice"
    case $choice in
        1)
           chmod +x ./source/main.sh
           ./source/main.sh
            ;;
        2)
           chmod +x ./docker/main.sh
           ./docker/main.sh
            ;;
        3)
           chmod +x ./ssh/main.sh
           ./ssh/main.sh
            ;;
        4)
           chmod +x ./golang/main.sh
           ./golang/main.sh
            ;;
        5)
           chmod +x ./git/main.sh
           ./git/main.sh
            ;;
        0)
            break
            ;;
    esac
done