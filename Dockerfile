# Use Node.js official image as the base
FROM node:18-alpine

# Define backup version environment variable with a default value
ARG KUMA_DATA_BACKUP_VERSION
RUN echo "KUMA_DATA_BACKUP_VERSION: ${KUMA_DATA_BACKUP_VERSION}"
ENV KUMA_DATA_BACKUP_VERSION=${KUMA_DATA_BACKUP_VERSION:-v2}

# Create the choreo user and group
RUN addgroup -g 10014 choreo && \
    adduser -D -u 10014 -G choreo choreouser

# Install required dependencies
RUN apk add --no-cache git python3 make g++

# Create app directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/louislam/uptime-kuma.git .

# Install dependencies and run setup
RUN npm run setup

# Install PM2 globally
RUN npm install pm2 -g && pm2 install pm2-logrotate

# Create data directory and copy backup files
RUN mkdir -p /app/data
COPY kuma-uptime-backups/${KUMA_DATA_BACKUP_VERSION}/data/kuma.db /app/data/
COPY kuma-uptime-backups/${KUMA_DATA_BACKUP_VERSION}/data/kuma.db-shm /app/data/
COPY kuma-uptime-backups/${KUMA_DATA_BACKUP_VERSION}/data/kuma.db-wal /app/data/
COPY kuma-uptime-backups/${KUMA_DATA_BACKUP_VERSION}/data/screenshots /app/data/screenshots/

# Set correct permissions
RUN chown -R choreouser:choreo /app/data

# Expose the default port
EXPOSE 3001

# Explicitly set USER to 10014 (choreouser)
USER 10014

# Set environment variable for the data directory
ENV UPTIME_KUMA_DATA_DIR=/app/data

# Start the application using PM2
CMD ["pm2-runtime", "server/server.js", "--name", "uptime-kuma"]
