# backend.Dockerfile
FROM node:20-bullseye

WORKDIR /app/backend

# Copy only package files first to take advantage of caching
COPY backend/package*.json ./

# Install dependencies
RUN npm install

# Copy backend source code
COPY backend/ ./

EXPOSE 8545

# Start Hardhat node when container runs
CMD ["npx", "hardhat", "node"]

