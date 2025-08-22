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
# Using npm install for better compatibility in some environments
RUN npm install

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

# Set JWT Secret (you should override this in production)
ARG JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
ENV JWT_SECRET=${JWT_SECRET}

# Set App Keys for encryption (you should override this in production)
ARG APP_KEYS=your-app-keys-here
ENV APP_KEYS=${APP_KEYS}

# Set API Token Salt (you should override this in production)
ARG API_TOKEN_SALT=your-api-token-salt-here
ENV API_TOKEN_SALT=${API_TOKEN_SALT}

# Set Admin JWT Secret (you should override this in production)
ARG ADMIN_JWT_SECRET=your-admin-jwt-secret-here
ENV ADMIN_JWT_SECRET=${ADMIN_JWT_SECRET}

# Set Transfer Token Salt (you should override this in production)
ARG TRANSFER_TOKEN_SALT=your-transfer-token-salt-here
ENV TRANSFER_TOKEN_SALT=${TRANSFER_TOKEN_SALT}

# Set Encryption Key (you should override this in production)
ARG ENCRYPTION_KEY=your-encryption-key-here
ENV ENCRYPTION_KEY=${ENCRYPTION_KEY}

# Copy built application from the builder stage
COPY --from=builder /opt/app /opt/app
# Copy production node_modules from the builder stage
COPY --from=builder /opt/node_modules /opt/node_modules

# Set the working directory
WORKDIR /opt/app

# Add node user and set permissions
RUN if ! getent group node > /dev/null; then addgroup -S node; fi
RUN if ! getent passwd node > /dev/null; then adduser -S node -G node; fi
RUN chown -R node:node /opt/app
RUN chown -R node:node /opt/node_modules

# Switch to non-root user
USER node

# Expose Strapi port
EXPOSE 1337

# Start the application in production mode
CMD ["npm", "run", "start"]