# Vite 配置说明

## 解决 "Blocked request" 错误

如果你遇到以下错误：

```
Blocked request. This host ("strapi.shenzjd.com") is not allowed.
To allow this host, add "strapi.shenzjd.com" to `server.allowedHosts` in vite.config.js.
```

## 解决方案

### 方法 1: 使用环境变量（推荐）

1. 在项目根目录创建 `.env` 文件：

```bash
# 允许的主机列表，用逗号分隔
VITE_ALLOWED_HOSTS=localhost,127.0.0.1,strapi.shenzjd.com
```

2. 重启开发服务器：

```bash
pnpm dev
```

### 方法 2: 直接修改配置文件

如果需要添加更多主机，可以直接修改 `src/admin/vite.config.ts` 文件中的 `allowedHosts` 数组。

## 环境变量说明

- `VITE_ALLOWED_HOSTS`: 允许访问的主机列表，多个主机用逗号分隔
- 默认值: `localhost,127.0.0.1,strapi.shenzjd.com`

## 示例

```bash
# 允许单个主机
VITE_ALLOWED_HOSTS=strapi.shenzjd.com

# 允许多个主机
VITE_ALLOWED_HOSTS=localhost,127.0.0.1,strapi.shenzjd.com,dev.example.com

# 允许所有主机（不推荐用于生产环境）
VITE_ALLOWED_HOSTS=all
```
