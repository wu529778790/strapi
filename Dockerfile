FROM node:22-alpine
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

# Enable Corepack for pnpm management
RUN corepack enable
RUN corepack prepare pnpm@latest --activate

WORKDIR /opt/
COPY package.json pnpm-lock.yaml ./
RUN pnpm install -g node-gyp
RUN pnpm config set fetch-retry-maxtimeout 600000 -g && pnpm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["pnpm", "run", "build"]
EXPOSE 1337
CMD ["pnpm", "run", "develop"]
