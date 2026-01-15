FROM node:20-bullseye

WORKDIR /app/backend

# Copy package files first for caching
COPY backend/package*.json ./

# Install dependencies
RUN npm install

# Copy backend source code
COPY backend/ ./

EXPOSE 8545

CMD ["npx", "hardhat", "node"]
