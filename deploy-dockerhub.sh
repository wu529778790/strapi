#!/bin/bash

# Docker Hub 部署脚本
# 使用方法: ./deploy-dockerhub.sh [镜像标签]

set -e

# 默认镜像标签
IMAGE_TAG=${1:-latest}
DOCKERHUB_USERNAME=${DOCKERHUB_USERNAME:-"your-dockerhub-username"}
IMAGE_NAME="$DOCKERHUB_USERNAME/strapi-app"

echo "开始部署 Strapi 应用 (Docker Hub)..."
echo "镜像: $IMAGE_NAME:$IMAGE_TAG"

# 停止并删除旧容器
echo "停止旧容器..."
docker stop strapi-app || true
docker rm strapi-app || true

# 删除旧镜像
echo "删除旧镜像..."
docker rmi $IMAGE_NAME:$IMAGE_TAG || true

# 拉取最新镜像
echo "拉取最新镜像..."
docker pull $IMAGE_NAME:$IMAGE_TAG

# 创建数据卷（如果不存在）
echo "创建数据卷..."
docker volume create strapi-uploads || true

# 运行新容器
echo "启动新容器..."
docker run -d \
  --name strapi-app \
  --restart unless-stopped \
  -p 1337:1337 \
  -e NODE_ENV=production \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=${DATABASE_HOST:-localhost} \
  -e DATABASE_PORT=${DATABASE_PORT:-5432} \
  -e DATABASE_NAME=${DATABASE_NAME:-strapi} \
  -e DATABASE_USERNAME=${DATABASE_USERNAME:-strapi} \
  -e DATABASE_PASSWORD=${DATABASE_PASSWORD:-strapi123} \
  -e JWT_SECRET=${JWT_SECRET:-your-jwt-secret} \
  -e ADMIN_JWT_SECRET=${ADMIN_JWT_SECRET:-your-admin-jwt-secret} \
  -e APP_KEYS=${APP_KEYS:-key1,key2,key3,key4} \
  -e API_TOKEN_SALT=${API_TOKEN_SALT:-your-api-token-salt} \
  -e TRANSFER_TOKEN_SALT=${TRANSFER_TOKEN_SALT:-your-transfer-token-salt} \
  -v strapi-uploads:/app/public/uploads \
  $IMAGE_NAME:$IMAGE_TAG

# 清理未使用的镜像
echo "清理未使用的镜像..."
docker image prune -f

echo "部署完成！"
echo "应用运行在: http://localhost:1337"
echo "管理面板: http://localhost:1337/admin"
echo "使用的镜像: $IMAGE_NAME:$IMAGE_TAG"
