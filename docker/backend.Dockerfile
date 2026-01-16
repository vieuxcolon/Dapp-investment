# backend.Dockerfile
FROM node:20-bullseye

WORKDIR /app/backend

# Copy package files first for caching
COPY backend/package*.json ./

# Set ESM module type
RUN npm pkg set type="module"

# Install Hardhat 3.x stack with exact working versions
RUN npm install --save-dev \
    hardhat@3.1.4 \
    @nomicfoundation/hardhat-toolbox@3.0.0 \
    @nomicfoundation/hardhat-ethers@3.1.3 \
    @nomicfoundation/hardhat-chai-matchers@2.1.2 \
    ethers@6.16.0 \
    chai@^4.3.7 \
    --legacy-peer-deps

# Copy the backend source code
COPY backend/ ./

# Clean old artifacts and compile contracts
RUN rm -rf cache artifacts && npx hardhat compile

# Expose Hardhat default port
EXPOSE 8545

# Run Hardhat node on container start
CMD ["npx", "hardhat", "node"]
