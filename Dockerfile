# 构建阶段
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 启用 corepack 并设置 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# 复制 package.json 和 pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制源代码
COPY . .

# 构建应用
RUN pnpm run build

# 生产阶段
FROM node:18-alpine AS production

# 设置工作目录
WORKDIR /app

# 启用 corepack 并设置 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# 创建非 root 用户
RUN addgroup -g 1001 -S nodejs && \
    adduser -S strapi -u 1001

# 复制 package.json 和 pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 只安装生产依赖并清理缓存
RUN pnpm install --frozen-lockfile --prod && \
    pnpm store prune && \
    rm -rf /root/.pnpm-store

# 从构建阶段复制构建产物
COPY --from=builder --chown=strapi:nodejs /app/dist ./dist
COPY --from=builder --chown=strapi:nodejs /app/public ./public
COPY --from=builder --chown=strapi:nodejs /app/package.json ./package.json
COPY --from=builder --chown=strapi:nodejs /app/favicon.png ./favicon.png

# 创建上传目录并设置权限
RUN mkdir -p /app/public/uploads && \
    chown -R strapi:nodejs /app/public/uploads

# 切换到非 root 用户
USER strapi

# 暴露端口
EXPOSE 1337

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=1337

# 启动应用
CMD ["pnpm", "start"]
