#--- Build Stage ---
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    build-base \
    openssl && \
    apk upgrade --no-cache

# Copy and install ALL dependencies (dev + prod)
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .

# Generate Prisma client before building the app
RUN npx prisma generate

RUN npm run build


#--- Production Stage ---
FROM node:20-alpine AS runner

# Set environment
ENV NODE_ENV=production \
    PORT=3001

WORKDIR /app

# Install only the runtime OS package Prisma needs
RUN apk add --no-cache openssl && \
    apk upgrade --no-cache

# Create non-root user explicitly
# node user already exists in node:alpine
# but let's be explicit about ownership
RUN chown -R node:node /app

# Copy runtime manifest and Prisma schema before installing prod deps
COPY --from=builder --chown=node:node /app/package*.json ./
COPY --from=builder --chown=node:node /app/prisma ./prisma/

# Install ONLY production dependencies here
# instead of copying the full builder dependency tree
RUN npm ci --omit=dev && \
    npm cache clean --force

# Remove package-manager tooling from the runtime image after install.
# This keeps the production image smaller and avoids shipping npm's bundled deps.
RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/lib/node_modules/corepack \
    /opt/yarn-* && \
    rm -f /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack /usr/local/bin/yarn /usr/local/bin/yarnpkg

# Copy built application
COPY --from=builder --chown=node:node /app/dist ./dist
COPY entrypoint-script.sh ./entrypoint-script.sh 
RUN  chown node:node ./entrypoint-script.sh 
RUN chmod +x entrypoint-script.sh

# Switch to non-root user
USER node

# Document port
EXPOSE 3001

CMD ["./entrypoint-script.sh"]
