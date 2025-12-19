#!/bin/bash

# 获取系统代号
codename=$(lsb_release -cs)

# 生成官方源配置
cat > /etc/apt/sources.list << EOF
# Debian 软件源 - 官方镜像
deb https://deb.debian.org/debian/ $codename main contrib non-free
# deb-src https://deb.debian.org/debian/ $codename main contrib non-free

deb https://deb.debian.org/debian/ $codename-updates main contrib non-free
# deb-src https://deb.debian.org/debian/ $codename-updates main contrib non-free

deb https://deb.debian.org/debian/ $codename-backports main contrib non-free
# deb-src https://deb.debian.org/debian/ $codename-backports main contrib non-free

deb https://deb.debian.org/debian-security/ $codename-security main contrib non-free
# deb-src https://deb.debian.org/debian-security/ $codename-security main contrib non-free
EOF

echo "官方源已配置"
echo "开始更新列表"
apt update
echo "完成"
read -s -p "按回车键返回..." </dev/tty