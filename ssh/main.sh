#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
show_menu() {
    clear
    if command -v sshd >/dev/null 2>&1; then
        echo "SSH已安装"
        STATUS=$(sshd -T | grep -i permitrootlogin | awk '{print $2}')
        case $STATUS in
            yes) echo "root账户允许密码登录" ;;
            prohibit-password|without-password) echo "root账户只允许密钥登录" ;;
            no) echo "root账户完全禁止登录" ;;
            *) echo "root账户未知状态: $STATUS" ;;
        esac
        if sshd -T | grep -q "pubkeyauthentication yes"; then
            echo "公钥认证：已开启"
        else
            echo "公钥认证：已关闭"
        fi
        # if sshd -T | grep -q "PasswordAuthentication yes"; then
        #     echo "公钥认证：已开启"
        # else
        #     echo "公钥认证：已关闭"
        # fi
        echo 公钥路径：
        target="/root/.ssh/authorized_keys"
        if ! sshd -T | grep authorizedkeysfile | awk '{$1=""; print substr($0,2)}' | tr ' ' '\n' | grep -q "^$target$"; then
            # 获取配置行并添加
            line=$(grep -i "^#*authorizedkeysfile" /etc/ssh/sshd_config | head -1)
            
            if [ -n "$line" ]; then
                # 取消注释并追加
                sudo sed -i "/^#*authorizedkeysfile/ s/^#//i; s/$/ $target/i" /etc/ssh/sshd_config
            else
                # 添加新行
                sudo sed -i '$aAuthorizedKeysFile '"$target" /etc/ssh/sshd_config
            fi
            
            sudo systemctl restart ssh
            echo "已添加: $target"
        else
            echo "已存在: $target"
        fi
        # sshd -T | grep authorizedkeysfile | awk '{$1=""; print substr($0,2)}' | tr ' ' '\n'


        if grep -q "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKiXM5USsk5F0hXqEw9I7MnpBL7Uhy62Ah5IQXZOvgv" /root/.ssh/authorized_keys; then
            echo "固定密钥已存在"
        else
            echo "固定密钥不存在"
        fi
    else
        echo "SSH未安装"
    fi

    # 显示菜单
    # echo -e "${GREEN}================================${NC}"
    # echo -e "${GREEN}       系统管理脚本             ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${NC}1. 安装${NC}"
    echo -e "${NC}2. 允许root登陆${NC}"
    echo -e "${NC}3. 禁止root登陆${NC}"
    echo -e "${NC}4. 仅密钥root登陆${NC}"
    # echo -e "${NC}4. 允许密码登陆${NC}"
    # echo -e "${NC}4. 不允许密码登陆${NC}"
    echo -e "${NC}5. 添加固定公钥${NC}"
    echo -e "${YELLOW}0. 返回${NC}"
    echo -e "${GREEN}================================${NC}"
}
while true; do
    show_menu
    read -p "请选择: " choice
    case $choice in
        1)
            apt update
            apt install -y openssh-server
            ;;
        2)
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
            # 控制SSH是否允许使用密码认证方式登录。
            sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
            ;;
        3)
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            ;;
        4)
            sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
            ;;
        5)
            if grep -q "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKiXM5USsk5F0hXqEw9I7MnpBL7Uhy62Ah5IQXZOvgv" /root/.ssh/authorized_keys; then
                echo "固定密钥已存在"
            else
                echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKiXM5USsk5F0hXqEw9I7MnpBL7Uhy62Ah5IQXZOvgv">> /root/.ssh/authorized_keys
                echo "固定密钥添加完成"
            fi
            ;;
        0)
            break
            ;;
    esac
    read -s -p "按回车键返回..." </dev/tty
    break

done