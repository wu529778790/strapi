# strapi.shenzjd.com

一个基于 Strapi 框架的项目,提供了一个快速搭建和部署 Strapi 应用程序的解决方案。该项目包含了项目的基本结构和配置文件,并提供了相关的部署脚本和 Docker 部署方案。

## Docker 部署

```bash
# GHCR
docker pull ghcr.io/wu529778790/strapi.shenzjd.com:latest
docker run --name strapi -p 1337:1337 -d ghcr.io/wu529778790/strapi.shenzjd.com:latest

# Docker Hub
docker pull docker.io/wu529778790/strapi.shenzjd.com:latest
docker run --name strapi -p 1337:1337 -d docker.io/wu529778790/strapi.shenzjd.com:latest
```

## 📚 Learn more

- [Resource center](https://strapi.io/resource-center) - Strapi resource center.
- [Strapi documentation](https://docs.strapi.io) - Official Strapi documentation.
- [Strapi tutorials](https://strapi.io/tutorials) - List of tutorials made by the core team and the community.
- [Strapi blog](https://strapi.io/blog) - Official Strapi blog containing articles made by the Strapi team and the community.
- [Changelog](https://strapi.io/changelog) - Find out about the Strapi product updates, new features and general improvements.

Feel free to check out the [Strapi GitHub repository](https://github.com/strapi/strapi). Your feedback and contributions are welcome!
