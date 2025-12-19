#!/bin/bash

# 获取系统代号
codename=$(lsb_release -cs)

# 生成中科大源配置
cat > /etc/apt/sources.list << EOF
# Debian 软件源 - 中科大镜像
deb https://mirrors.ustc.edu.cn/debian/ $codename main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ $codename main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ $codename-updates main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ $codename-updates main contrib non-free

deb https://mirrors.ustc.edu.cn/debian/ $codename-backports main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian/ $codename-backports main contrib non-free

deb https://mirrors.ustc.edu.cn/debian-security/ $codename-security main contrib non-free
# deb-src https://mirrors.ustc.edu.cn/debian-security/ $codename-security main contrib non-free
EOF

echo "中科大源已配置"
echo "开始更新列表"
apt update
echo "完成"
read -s -p "按回车键返回..." </dev/tty