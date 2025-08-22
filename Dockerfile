FROM node:22-alpine
# Installing libvips-dev for sharp Compatibility and sqlite for building
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev sqlite-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app
COPY package.json yarn.lock ./
RUN yarn global add node-gyp
RUN yarn config set network-timeout 600000 -g && yarn install
ENV PATH=/opt/app/node_modules/.bin:$PATH

COPY . .
RUN chown -R node:node /opt/app
USER node
RUN yarn build
EXPOSE 1337
CMD ["yarn", "start"]