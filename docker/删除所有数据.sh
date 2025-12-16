#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
echo -e "${RED}警告：这将删除所有 Docker 数据${NC}"
echo -e "${RED}警告：这将删除镜像、容器、存储卷、网络等${NC}"
echo -e "${RED}警告：此操作不可逆！${NC}"
read -p "是否删除 (y?): " ans

if [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]; then
    echo "清理 Docker 数据..."
    echo "1. 停止所有容器..."
    docker stop $(docker ps -aq) 2>/dev/null || true

    echo "2. 删除所有容器..."
    docker rm $(docker ps -aq) 2>/dev/null || true

    echo "3. 删除所有镜像..."
    docker rmi $(docker images -q) 2>/dev/null || true

    echo "4. 删除所有存储卷..."
    docker volume rm $(docker volume ls -q) 2>/dev/null || true

    echo "5. 删除所有网络..."
    docker network rm $(docker network ls -q) 2>/dev/null || true

    echo "6. 清理构建缓存..."
    docker builder prune -af 2>/dev/null || true

    echo "✓ Docker 数据已清理"

fi