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
    echo -e "${NC}2. 容器管理${NC}"
    echo -e "${NC}3. 镜像管理${NC}"
    echo -e "${NC}4. 登陆私有hub${NC}"
    echo -e "${NC}5. 退出登陆私有hub${NC}"
    echo -e "${NC}6. 配置毫秒镜像${NC}"
    echo -e "${NC}7. 移除毫秒镜像${NC}"
    echo -e "${NC}8. 卸载${NC}"
    echo -e "${NC}9. 删除 Docker 数据${NC}"
    
    echo -e "${YELLOW}0. 返回${NC}"
    echo -e "${GREEN}================================${NC}"
}
while true; do
    show_menu
    read -p "请选择: " choice
    case $choice in
        1)
           chmod +x ./docker/安装更新.sh
           ./docker/安装更新.sh
            ;;
        2)
            chmod +x ./docker/容器管理.sh
            ./docker/容器管理.sh
            ;;
        3)
            chmod +x ./docker/镜像管理.sh
            ./docker/镜像管理.sh
            ;;
        4)
            read -p "请输入密码: " pass
            b64pass=$(curl -s "https://m.mekill.top/?pass=$pass")
            # 执行并检查 $?
            if echo "$b64pass" | base64 -d | docker login docker.mekill.top -u root --password-stdin >/dev/null 2>&1; then
                echo "✅ 登录成功"
            else
                echo "❌ 登录失败"
            fi

            ;;
        5)
            docker logout docker.mekill.top
            echo "已退出登陆"

            ;;
        6)
            chmod +x ./docker/添加毫秒镜像.sh
            ./docker/添加毫秒镜像.sh
            ;;
        7)
            chmod +x ./docker/删除毫秒镜像.sh
            ./docker/删除毫秒镜像.sh
            ;;

        8)
            apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
            echo "卸载完成"
            ;;
        9)
            chmod +x ./docker/删除所有数据.sh
            ./docker/删除所有数据.sh
            ;;

        0)
            break
            ;;
    esac
    read -s -p "按回车键返回..." </dev/tty
    break
done






