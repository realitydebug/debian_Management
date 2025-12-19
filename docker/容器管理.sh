#!/bin/bash
# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
show_menu() {
    clear
    echo -e "${GREEN}================================${NC}"
    echo "容器列表:"
    # docker ps --format "table {{.Image}}\t{{.Names}}"
    # docker ps -a --format "table {{.Names}}\t{{.Image}}" | awk 'NR==1 {print "编号 | "$0} NR>1 {printf "%-4s | %s\n", NR-1, $0}'
    docker ps -a --format "{{.Names}}\t{{.Image}}\t{{.Status}}" | awk '{
        status = "未运行"
        if($3 ~ /^Up/) status = "运行中"
        
        # 截断容器名最多10个字符
        name = $1
        if(length(name) > 10) name = substr(name, 1, 7) "..."
        
        printf "%-4s | %-10s | %-10s | %s\n", NR, status, name, $2
    }'
    echo -e "${GREEN}================================${NC}"

}

# 获取选择的容器信息
# get_container_info() {
#     # 获取指定编号的容器信息,容器名，镜像名
#     container_line=$(docker ps -a --format "{{.Names}}|{{.Image}}" | sed -n "${1}p")
#     if [ -n "$container_line" ]; then
#         IFS='|' read -r container_name image_name <<< "$container_line"
#         echo "$container_name $image_name"
#     fi
# }
# 获取选择的容器信息
get_container_info() {
    # 获取指定编号的容器信息：容器名，镜像名，运行状态
    container_line=$(docker ps -a --format "{{.Names}}|{{.Image}}|{{.Status}}" | sed -n "${1}p")
    if [ -n "$container_line" ]; then
        IFS='|' read -r container_name image_name status <<< "$container_line"
        
        # 判断容器是否在运行（Status包含"Up"表示正在运行）
        if [[ "$status" =~ "Up" ]]; then
            is_running=1
        else
            is_running=0
        fi
        
        # 返回三个值：容器名 镜像名 是否运行(1运行/0停止)
        echo "$container_name $image_name $is_running"
    fi
}


while true; do
    show_menu
    echo -e "${RED}输入0返回${NC}"
    read -p "请选择: " input
    clear
    # if docker ps -a --format "{{.Names}}" | grep -q "$name"; then
    result=$(get_container_info "$input")
    if [ -z "$input" ] || [ "$input" -eq 0 ]; then
        break
    fi
    if [ -n "$result" ]; then
        read container_name image_name is_running <<< "$result"
        echo "容器名: $container_name"
        echo "镜像名: $image_name"
        [ "$is_running" -eq 1 ] && echo "状态: 运行中" || echo "状态: 未运行"
        if docker ps -a --format "{{.Names}}" | grep -q "$container_name"; then
            echo -e "${GREEN}================================${NC}"
            echo -e "${NC}1. 启动${NC}"
            echo -e "${NC}2. 停止${NC}"
            echo -e "${NC}3. 重启${NC}"
            echo -e "${NC}4. 更新${NC}"
            echo -e "${NC}5. 删除${NC}"
            echo -e "${NC}6. 进入交互${NC}"
            echo -e "${YELLOW}0. 返回${NC}"
            echo -e "${GREEN}================================${NC}"
            read -p "请选择: " choice
            case $choice in
                1)
                    docker start "$container_name"
                    echo "启动成功"
                    ;;
                2)
                    docker stop "$container_name"
                    echo "停止成功"
                    ;;
                3)
                    docker restart "$container_name"
                    echo "重启成功"
                    ;;
                4)
                    chmod +x ./docker/提取容器run.sh
                    run=$(./docker/提取容器run.sh "$container_name")
                    echo "$run"
                    docker pull "$image_name"
                    # docker stop "$container_name"
                    docker rm -f "$container_name"
                    echo 启动中
                    eval "$run"
                    if [ "$is_running" -eq 0 ]; then
                        echo 停止容器
                        docker stop "$container_name"
                    fi
                    echo "完成"
                    ;;
                5)
                    read -p "确认删除 (y?): " ans
                    if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
                        docker rm -f "$container_name"
                        echo "删除完成"
                    fi

                    ;;
                6)
                    if docker exec "$container_name" which bash >/dev/null 2>&1; then
                        docker exec -it "$container_name" bash
                    else
                        docker exec -it "$container_name" sh
                    fi
                    ;;
                0)
                    break
                    ;;
                    
            esac
        else
            echo "容器不存在"
            sleep 1
        fi

        # read -s -p "按回车键返回..." </dev/tty
    else
        echo "无效的选择!"
        # read -s -p "按回车键返回..." </dev/tty
    fi
    read -s -p "按回车键返回..." </dev/tty
done
