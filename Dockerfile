# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# Install system dependencies + jq
RUN apt-get update -y && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Node.js 20 + npm 10
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Global Node tools
RUN npm install -g \
    typescript@5.2.2 \
    ts-node@10.9.1 \
    hardhat@2.17.2 \
    ethers@6.9.0 \
    next@16.1.2 \
    react@18.2.0 \
    react-dom@18.2.0

# Expose common ports
EXPOSE 8545 4000 3000

# Copy runtime automation script (make sure run-all.sh is inside ./docker)
COPY run-all.sh /workspace/run-all.sh
RUN chmod +x /workspace/run-all.sh

# Default command: run automation script
CMD ["/workspace/run-all.sh"]
