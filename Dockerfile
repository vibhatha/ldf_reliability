# Use Node.js official image as the base
FROM node:18-alpine

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

# Create volume directory and copy backup data
RUN mkdir -p /app/data
COPY ./kuma-uptime-backups/data /app/data/

# Expose the default port
EXPOSE 3001

# Set environment variable for the data directory
ENV UPTIME_KUMA_DATA_DIR=/app/data

# Start the application using PM2
CMD ["pm2-runtime", "server/server.js", "--name", "uptime-kuma"]
