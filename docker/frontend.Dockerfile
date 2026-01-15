# docker/frontend.Dockerfile
FROM node:20-bullseye

# Set working directory
WORKDIR /app/frontend

# Copy package files and install dependencies
COPY frontend/package*.json ./

# Pin npm version for stability
RUN npm install -g npm@10.1.0

# Install frontend dependencies
RUN npm install

# Copy frontend source code
COPY frontend/ ./

# Expose React dev server port
EXPOSE 3000

# Start frontend
CMD ["npm", "start"]
