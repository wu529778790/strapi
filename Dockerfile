# --- BUILDER ---
# Stage 1: Build the application
FROM node:22-alpine AS builder

# Installing libvips-dev for sharp Compatibility and sqlite for building
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev sqlite-dev

# Set build-time argument
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
# Copy package files and install dependencies
COPY package.json package-lock.json ./
# Use npm ci for faster, more reliable builds in CI/CD environments
RUN npm ci

WORKDIR /opt/app
# Copy the rest of the application source code
COPY . .

# Build the Strapi admin panel
RUN npm run build

# --- RUNNER ---
# Stage 2: Create the final, lean production image
FROM node:22-alpine

# Install only runtime dependencies
RUN apk add --no-cache vips sqlite

# Set production environment
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/

# Copy production node_modules from the builder stage
COPY --from=builder /opt/node_modules ./node_modules

WORKDIR /opt/app

# Copy built application and configurations from the builder stage
COPY --from=builder /opt/app .

# Add node user and set permissions
RUN addgroup -g 1001 -S node && \
    adduser -u 1001 -S node -G node && \
    chown -R node:node /opt/app && \
    chown -R node:node /opt/node_modules

# Switch to non-root user
USER node

# Expose Strapi port
EXPOSE 1337

# Start the application in production mode
CMD ["npm", "run", "start"]
