# Docker 部署指南

这个项目配置了完整的 Docker 化部署方案，包括自动构建和部署到服务器。

## 文件说明

- `Dockerfile` - Docker 镜像构建文件
- `.dockerignore` - Docker 构建时忽略的文件
- `.github/workflows/docker-deploy.yml` - GitHub Actions 自动部署工作流
- `docker-compose.yml` - 本地开发和测试用的 Docker Compose 配置
- `deploy.sh` - GitHub Container Registry 部署脚本
- `deploy-dockerhub.sh` - Docker Hub 部署脚本

## 本地测试

### 使用 Docker Compose

```bash
# 启动完整的开发环境（包括 PostgreSQL 数据库）
docker-compose up -d

# 查看日志
docker-compose logs -f strapi

# 停止服务
docker-compose down
```

### 直接构建 Docker 镜像

```bash
# 构建镜像
docker build -t strapi-app .

# 运行容器
docker run -d \
  --name strapi-app \
  -p 1337:1337 \
  -e DATABASE_HOST=your-db-host \
  -e DATABASE_PASSWORD=your-db-password \
  strapi-app
```

## GitHub Actions 自动部署

### 1. 设置 GitHub Secrets

在你的 GitHub 仓库中，进入 Settings > Secrets and variables > Actions，添加以下 secrets：

**服务器连接信息：**

- `SERVER_HOST` - 服务器 IP 地址
- `SERVER_USERNAME` - SSH 用户名
- `SERVER_SSH_KEY` - SSH 私钥
- `SERVER_PORT` - SSH 端口（默认 22）

**Docker Hub 配置：**

- `DOCKERHUB_USERNAME` - Docker Hub 用户名
- `DOCKERHUB_TOKEN` - Docker Hub 访问令牌

**数据库配置：**

- `DATABASE_HOST` - 数据库主机地址
- `DATABASE_PORT` - 数据库端口（默认 5432）
- `DATABASE_NAME` - 数据库名称
- `DATABASE_USERNAME` - 数据库用户名
- `DATABASE_PASSWORD` - 数据库密码

**Strapi 安全配置：**

- `JWT_SECRET` - JWT 密钥
- `ADMIN_JWT_SECRET` - 管理员 JWT 密钥
- `APP_KEYS` - 应用密钥（逗号分隔）
- `API_TOKEN_SALT` - API 令牌盐值
- `TRANSFER_TOKEN_SALT` - 传输令牌盐值

### 2. 创建 Docker Hub 访问令牌

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 进入 Account Settings > Security
3. 点击 "New Access Token"
4. 输入令牌名称（如 "GitHub Actions"）
5. 选择权限（建议选择 "Read & Write"）
6. 复制生成的令牌并保存到 GitHub Secrets 中的 `DOCKERHUB_TOKEN`

### 3. 生成安全密钥

使用以下命令生成安全密钥：

```bash
# JWT 密钥
openssl rand -base64 32

# 应用密钥（生成 4 个）
openssl rand -base64 32
openssl rand -base64 32
openssl rand -base64 32
openssl rand -base64 32

# API 令牌盐值
openssl rand -base64 32

# 传输令牌盐值
openssl rand -base64 32
```

### 4. 工作流触发

- 推送到 `main` 或 `master` 分支会自动触发构建和部署
- 创建 Pull Request 会触发构建但不部署
- 镜像会同时推送到 GitHub Container Registry 和 Docker Hub

## 服务器部署

### 1. 服务器准备

确保服务器已安装 Docker：

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 启动 Docker 服务
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. 手动部署

#### 使用 GitHub Container Registry

将 `deploy.sh` 脚本上传到服务器，并修改其中的镜像名称：

```bash
# 给脚本执行权限
chmod +x deploy.sh

# 设置环境变量
export DATABASE_HOST=your-db-host
export DATABASE_PASSWORD=your-db-password
# ... 其他环境变量

# 运行部署脚本
./deploy.sh
```

#### 使用 Docker Hub

将 `deploy-dockerhub.sh` 脚本上传到服务器：

```bash
# 给脚本执行权限
chmod +x deploy-dockerhub.sh

# 设置环境变量
export DOCKERHUB_USERNAME=your-dockerhub-username
export DATABASE_HOST=your-db-host
export DATABASE_PASSWORD=your-db-password
# ... 其他环境变量

# 运行部署脚本
./deploy-dockerhub.sh
```

### 3. 自动部署

配置好 GitHub Secrets 后，每次推送到主分支都会自动部署。默认会使用 Docker Hub 镜像进行部署。

## 环境变量

### 必需的环境变量

- `DATABASE_HOST` - 数据库主机
- `DATABASE_PORT` - 数据库端口
- `DATABASE_NAME` - 数据库名称
- `DATABASE_USERNAME` - 数据库用户名
- `DATABASE_PASSWORD` - 数据库密码

### 安全相关的环境变量

- `JWT_SECRET` - JWT 签名密钥
- `ADMIN_JWT_SECRET` - 管理员 JWT 密钥
- `APP_KEYS` - 应用密钥（逗号分隔的 4 个密钥）
- `API_TOKEN_SALT` - API 令牌盐值
- `TRANSFER_TOKEN_SALT` - 传输令牌盐值

## 故障排除

### 查看容器日志

```bash
# 查看应用日志
docker logs strapi-app

# 实时查看日志
docker logs -f strapi-app
```

### 进入容器调试

```bash
docker exec -it strapi-app sh
```

### 重启服务

```bash
docker restart strapi-app
```

### 清理资源

```bash
# 停止并删除容器
docker stop strapi-app
docker rm strapi-app

# 删除镜像
docker rmi ghcr.io/your-username/your-repo-name:latest

# 清理未使用的资源
docker system prune -f
```

## 注意事项

1. 确保数据库服务正在运行且可访问
2. 首次部署时，Strapi 会自动创建数据库表
3. 上传的文件会保存在 Docker 卷 `strapi-uploads` 中
4. 建议使用反向代理（如 Nginx）来处理 HTTPS 和域名
5. 定期备份数据库和上传文件
