# --- BUILDER ---
# Stage 1: Build the application
FROM node:22-alpine AS builder

# Installing libvips-dev for sharp Compatibility and sqlite for building
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev sqlite-dev

# Install pnpm globally
RUN npm install -g pnpm

WORKDIR /opt/app
# Copy package files and install dependencies
COPY package.json pnpm-lock.yaml ./
# Using pnpm install for better performance and compatibility
RUN pnpm install --frozen-lockfile

# Copy the rest of the application source code
COPY . .

# Build the Strapi admin panel
RUN pnpm run build

# --- RUNNER ---
# Stage 2: Create the final, lean production image
FROM node:22-alpine

# Install only runtime dependencies
RUN apk add --no-cache vips sqlite

# Copy built application from the builder stage
COPY --from=builder /opt/app /opt/app
# Copy production node_modules from the builder stage
COPY --from=builder /opt/app/node_modules /opt/app/node_modules

# Set the working directory
WORKDIR /opt/app

# Add node user and set permissions
RUN if ! getent group node > /dev/null; then addgroup -S node; fi
RUN if ! getent passwd node > /dev/null; then adduser -S node -G node; fi
RUN chown -R node:node /opt/app

# Switch to non-root user
USER node

# Expose Strapi port
EXPOSE 1337

# Start the application in production mode
CMD ["pnpm", "run", "develop"]