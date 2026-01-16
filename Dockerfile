# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Node.js 20 + npm 10
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# TypeScript globally
RUN npm install -g typescript@5.2.2 ts-node@10.9.1

# Hardhat + ethers globally
RUN npm install -g hardhat@2.17.2 ethers@6.9.0

# Next.js + React globally
RUN npm install -g next@14.3.2 react@18.2.0 react-dom@18.2.0

# Expose ports
EXPOSE 8545 4000 3000

# Copy runtime automation script
COPY run-all.sh /workspace/run-all.sh
RUN chmod +x /workspace/run-all.sh

# Run automation at container start
CMD ["/workspace/run-all.sh"]
