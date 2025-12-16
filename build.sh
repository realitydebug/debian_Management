#!/bin/bash
# 打包当前目录为自解压脚本

OUTPUT="app.js"
cat > $OUTPUT << 'EOF'
const sh=`
#!/bin/bash

TARGET="/tmp/qncg"
DATA_URL="https://h.mekill.top/b64"

echo "正在下载数据..."
rm -rf "$TARGET"
mkdir -p "$TARGET"

# 下载并解压数据
curl -s "$DATA_URL" | base64 -d | tar -xz -C "$TARGET"

echo "解压完成"

echo "正在运行 main.sh..."
cd "$TARGET"
chmod +x main.sh

./main.sh < /dev/tty
exit $?
`
const b64 = `
EOF

# 添加当前目录数据
tar -cz . 2>/dev/null | base64 >> "$OUTPUT"

cat >> $OUTPUT << 'EOF'
`
export default {
    async fetch(request, env, ctx) {
      const url = new URL(request.url);
      
      // 判断路径是否为 /b64
      if (url.pathname === '/b64') {
        // 返回指定的变量（这里用示例内容，你可以替换为实际变量）
        const sh = "这是指定变量的内容";
        return new Response(b64, {
          headers: { 'Content-Type': 'text/plain' }
        });
      }
      
      // 其他路径返回默认响应
      return new Response(sh, {
        headers: { 'Content-Type': 'text/plain' }
      });
    }
};
EOF
echo "打包完成!"

