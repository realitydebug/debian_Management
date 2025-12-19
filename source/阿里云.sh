#!/bin/bash

# 获取系统代号
codename=$(lsb_release -cs)

# 生成阿里云源配置
cat > /etc/apt/sources.list << EOF
# Debian 软件源 - 阿里云镜像
deb https://mirrors.aliyun.com/debian/ $codename main contrib non-free
# deb-src https://mirrors.aliyun.com/debian/ $codename main contrib non-free

deb https://mirrors.aliyun.com/debian/ $codename-updates main contrib non-free
# deb-src https://mirrors.aliyun.com/debian/ $codename-updates main contrib non-free

deb https://mirrors.aliyun.com/debian/ $codename-backports main contrib non-free
# deb-src https://mirrors.aliyun.com/debian/ $codename-backports main contrib non-free

deb https://mirrors.aliyun.com/debian-security/ $codename-security main contrib non-free
# deb-src https://mirrors.aliyun.com/debian-security/ $codename-security main contrib non-free
EOF

echo "阿里云源已配置"
echo "开始更新列表"
apt update
echo "完成"
read -s -p "按回车键返回..." </dev/tty