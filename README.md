# strapi

一个基于 Strapi 框架的项目,提供了一个快速搭建和部署 Strapi 应用程序的解决方案。该项目包含了项目的基本结构和配置文件,并提供了相关的部署脚本和 Docker 部署方案。

> 官方不提供 docker 镜像, 所以自己构建镜像

## Docker 部署

### 镜像拉取

```bash
# GHCR
docker pull ghcr.io/wu529778790/strapi:latest
docker run --name strapi -p 1337:1337 -d ghcr.io/wu529778790/strapi:latest

# Docker Hub
docker pull docker.io/wu529778790/strapi:latest
docker run --name strapi -p 1337:1337 -d docker.io/wu529778790/strapi:latest
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

### 生成密钥

```bash
node -e "console.log(require('crypto').randomBytes(16).toString('base64'))"
```

您需要生成三个独立的密钥，并将它们以逗号分隔的形式设置在 `.env` 文件的 `APP_KEYS` 变量中，例如：

`APP_KEYS=key1,key2,key3`

## 📚 Learn more

- [docker](<https://docs.strapi.io/cms/installation/docker>)
- [Resource center](https://strapi.io/resource-center) - Strapi resource center.
- [Strapi documentation](https://docs.strapi.io) - Official Strapi documentation.
- [Strapi tutorials](https://strapi.io/tutorials) - List of tutorials made by the core team and the community.
- [Strapi blog](https://strapi.io/blog) - Official Strapi blog containing articles made by the Strapi team and the community.
- [Changelog](https://strapi.io/changelog) - Find out about the Strapi product updates, new features and general improvements.

Feel free to check out the [Strapi GitHub repository](https://github.com/strapi/strapi). Your feedback and contributions are welcome!
