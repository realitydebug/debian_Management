#!/bin/bash



file="/etc/docker/daemon.json"

# 检查文件是否存在
if [ ! -f "$file" ]; then
    echo "配置文件不存在"
    exit 0
fi

# 检查是否包含目标镜像
if ! grep -q "docker.1ms.run" "$file"; then
    echo "目标镜像不存在"
    exit 0
fi

# 删除目标镜像
sed -i '/docker\.1ms\.run/d' "$file"

# 清理可能留下的空数组
sed -i 's/"registry-mirrors": \[[[:space:]]*\]/"registry-mirrors": []/' "$file"
sed -i 's/"registry-mirrors": \[[[:space:]]*\]//' "$file"

echo "已删除 docker.1ms.run 镜像"

