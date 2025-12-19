#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_menu() {
# docker images -a
    clear
    docker images --format "table {{.Repository}}:{{.Tag}}" | awk '
    NR==1 {
        print "┌──────┬────────────────────────────────────────────┐"
        print "│ 编号 │ IMAGE                                      │"
        print "├──────┼────────────────────────────────────────────┤"
    }
    NR>1 {
        printf "│ %4d │ %-42s │\n", NR-1, $0
    }
    END {
        print "└──────┴────────────────────────────────────────────┘"
    }'
}
get_image_info() {
    # 获取指定编号的镜像名
    docker images --format "{{.Repository}}:{{.Tag}}" | sed -n "${1}p"
}

while true; do
    show_menu
    echo -e "${RED}输入0返回${NC}"
    read -p "请选择: " input
    clear
    result=$(get_image_info "$input")
    if [ -z "$input" ] || [ "$input" -eq 0 ]; then
        break
    fi
    if [ -n "$result" ]; then
        read image_name <<< "$result"
        
        echo "镜像名: $image_name"
        if docker ps -a --filter "ancestor=$image_name" --quiet | grep -q .; then
            echo "有容器使用此镜像"
        else
            echo "没有容器使用此镜像"
        fi
        echo -e "${GREEN}================================${NC}"
        echo -e "${NC}1. 更新${NC}"
        echo -e "${NC}2. 删除${NC}"
        echo -e "${NC}9. 删除所有悬空镜像${NC}"
        echo -e "${YELLOW}0. 返回${NC}"
        echo -e "${GREEN}================================${NC}"
        read -p "请选择: " choice
        case $choice in
            1)
                docker pull "$image_name"
                echo "已执行更新"
                ;;
            2)
                docker rmi "$image_name"
                echo "已执行删除"
                echo "如果正在被使用将删除失败"
                ;;
            9)
                docker image prune -f
                echo "已执行清理"
                ;;
            0)
                break
                ;;
        esac
    else
        echo "无效的选择!"
        
    fi
    read -s -p "按回车键返回..." </dev/tty
done



# # 删除所有悬空镜像
# docker image prune
# # 强制删除（不确认）
# docker image prune -f
# # 删除所有未被使用的镜像（包括悬空镜像和未被容器使用的镜像）
# docker image prune -a