#!/bin/bash
# 打包当前目录为自解压脚本

OUTPUT="app.txt"


# 添加当前目录数据
tar -cz . 2>/dev/null | base64 > "$OUTPUT"
chmod +x "$OUTPUT"

echo "打包完成!"

