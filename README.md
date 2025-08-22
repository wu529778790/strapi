# strapi

一个基于 Strapi 框架的项目,提供了一个快速搭建和部署 Strapi 应用程序的解决方案。该项目包含了项目的基本结构和配置文件,并提供了相关的部署脚本和 Docker 部署方案。

> 官方不提供 docker 镜像, 所以自己构建镜像

## 🚀 快速开始

### 方法1：使用 Docker Compose（推荐）

1. 生成安全密钥：

```bash
node generate-secrets.js
```

2. 创建 `.env` 文件并添加生成的密钥

3. 启动服务：

```bash
docker-compose up -d
```

### 方法2：直接使用 Docker

1. 构建镜像：

```bash
docker build -t strapi .
```

2. 运行容器（使用默认密钥）：

```bash
docker run --name strapi -p 1337:1337 -d strapi
```

3. 运行容器（使用自定义密钥）：

```bash
docker run --name strapi -p 1337:1337 \
  -e JWT_SECRET=your-custom-jwt-secret \
  -d strapi
```

## Docker 部署

### 镜像拉取

```bash
# GHCR
docker pull ghcr.io/wu529778790/strapi.shenzjd.com:latest
docker run --name strapi.shenzjd.com -p 1337:1337 -d ghcr.io/wu529778790/strapi.shenzjdcom:latest

# Docker Hub
docker pull docker.io/wu529778790/strapi.shenzjd.com:latest
docker run --name strapi.shenzjd.com -p 1337:1337 -d docker.io/wu529778790/strapi.shenzjd.com:latest
```

### 环境变量

| 变量名             | 描述                                                         |
|--------------------|--------------------------------------------------------------|
| NODE_ENV           | 应用运行的环境。                                              |
| DATABASE_CLIENT    | 要使用的数据库客户端。                                        |
| DATABASE_HOST      | 数据库主机地址。                                              |
| DATABASE_PORT      | 数据库端口。                                                  |
| DATABASE_NAME      | 数据库名称。                                                  |
| DATABASE_USERNAME  | 数据库用户名。                                                |
| DATABASE_PASSWORD  | 数据库密码。                                                  |
| JWT_SECRET         | 用于 Users-Permissions 插件 JWT 签名的密钥。                  |
| ADMIN_JWT_SECRET   | 用于管理后台 JWT 签名的密钥。                                 |
| APP_KEYS           | 用于签名会话 cookie 的密钥。                                  |
| ENCRYPTION_KEY     | 用于加密管理后台数据的密钥。                                  |

### 常见问题

#### JWT_SECRET 缺失错误

如果遇到以下错误：

```
Missing jwtSecret. Please, set configuration variable "jwtSecret" for the users-permissions plugin
```

解决方案：

1. 使用 `node generate-secrets.js` 生成安全密钥
2. 在运行 Docker 容器时设置环境变量：

   ```bash
   docker run --name strapi -p 1337:1337 \
     -e JWT_SECRET=your-generated-jwt-secret \
     -d strapi
   ```

3. 或者使用 docker-compose：

   ```bash
   docker-compose up -d
   ```

## 📚 Learn more

- [docker](<https://docs.strapi.io/cms/installation/docker>)
- [Resource center](https://strapi.io/resource-center) - Strapi resource center.
- [Strapi documentation](https://docs.strapi.io) - Official Strapi documentation.
- [Strapi tutorials](https://strapi.io/tutorials) - List of tutorials made by the core team and the community.
- [Strapi blog](https://strapi.io/blog) - Official Strapi blog containing articles made by the Strapi team and the community.
- [Changelog](https://strapi.io/changelog) - Find out about the Strapi product updates, new features and general improvements.

Feel free to check out the [Strapi GitHub repository](https://github.com/strapi/strapi). Your feedback and contributions are welcome!
