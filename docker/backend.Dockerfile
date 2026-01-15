# docker/backend.Dockerfile
FROM node:20-bullseye

# Set working directory
WORKDIR /app/backend

# Copy package files and install dependencies
COPY backend/package*.json ./

# Pin npm version (optional, stability)
RUN npm install -g npm@10.1.0

# Install backend dependencies
RUN npm install

# Copy backend source code
COPY backend/ ./

# Expose Hardhat network port
EXPOSE 8545

# Default command: compile contracts & run Hardhat node
CMD ["npx", "hardhat", "node"]
