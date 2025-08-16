FROM node:22-alpine
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
ENV ALLOWED_HOST=strapi.shenzjd.com

# Enable Corepack for pnpm management
RUN corepack enable
RUN corepack prepare pnpm@latest --activate

WORKDIR /opt/app
COPY package.json pnpm-lock.yaml ./
RUN pnpm config set fetch-retry-maxtimeout 600000 -g && pnpm install
ENV PATH=/opt/app/node_modules/.bin:$PATH

COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["pnpm", "run", "build"]
EXPOSE 1337
CMD ["pnpm", "run", "develop"]
