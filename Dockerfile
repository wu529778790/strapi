# --- BUILDER ---
# Stage 1: Build the application
FROM node:22-alpine AS builder

# Installing only necessary build dependencies
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    nasm \
    vips-dev \
    sqlite-dev \
    python3 \
    make

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build the application
RUN npm run build

# --- RUNNER ---
# Stage 2: Create the final, lean production image
FROM node:22-alpine

# Install only runtime dependencies
RUN apk add --no-cache \
    vips \
    sqlite \
    dumb-init

# Create app user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S strapi -u 1001

WORKDIR /opt/app

# Copy built application from builder stage
COPY --from=builder --chown=strapi:nodejs /opt/app/dist ./dist
COPY --from=builder --chown=strapi:nodejs /opt/app/public ./public
COPY --from=builder --chown=strapi:nodejs /opt/app/package.json ./package.json
COPY --from=builder --chown=strapi:nodejs /opt/app/node_modules ./node_modules
COPY --from=builder --chown=strapi:nodejs /opt/app/config ./config
COPY --from=builder --chown=strapi:nodejs /opt/app/src ./src
COPY --from=builder --chown=strapi:nodejs /opt/app/database ./database
COPY --from=builder --chown=strapi:nodejs /opt/app/favicon.png ./favicon.png
COPY --from=builder --chown=strapi:nodejs /opt/app/tsconfig.json ./tsconfig.json

# Switch to non-root user
USER strapi

# Expose Strapi port
EXPOSE 1337

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["npm", "run", "start"]
