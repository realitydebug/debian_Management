#!/bin/bash

config_file="/etc/docker/daemon.json"

# 如果文件不存在，创建
if [ ! -f "$config_file" ]; then
    echo '{}' > "$config_file"
fi

# 粗略判断是否已包含该镜像
if grep -q "docker.1ms.run" "$config_file"; then
    echo "镜像 https://docker.1ms.run 已存在"
    exit 0
fi

# 读取现有内容
content=$(cat "$config_file")

# 简单处理JSON
if [[ "$content" == "{}" ]] || [[ ! "$content" =~ "registry-mirrors" ]]; then
    # 空JSON或没有registry-mirrors字段
    echo '{"registry-mirrors": ["https://docker.1ms.run"]}' > "$config_file"
else
    # 有registry-mirrors字段，插入到数组开始
    # 简单替换：在第一个 [ 后插入
    sed -i 's/\["registry-mirrors": \[/\["registry-mirrors": \["https:\/\/docker.1ms.run", /' "$config_file"
    # 如果上面的没匹配到，用另一种方式
    if grep -q "docker.1ms.run" "$config_file"; then
        echo "已添加 https://docker.1ms.run 到镜像列表"
    else
        echo "添加失败，可能需要手动编辑 $config_file"
        exit 1
    fi
fi

echo "已添加 https://docker.1ms.run 到镜像列表"
