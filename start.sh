
#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# ------------------------------
# 1. Pre-start: install dependencies, compile contracts, export ABIs
# ------------------------------
./pre-start.sh

# ------------------------------
# 2. Build Docker containers (no cache)
# ------------------------------
echo "=========================================="
echo "Building Docker containers (no cache)..."
echo "=========================================="
docker compose build --no-cache

# ------------------------------
# 3. Start backend Hardhat node
# ------------------------------
echo "=========================================="
echo "Starting backend Hardhat node..."
echo "=========================================="
docker compose up -d backend

# ------------------------------
# 4. Wait for backend to initialize
# ------------------------------
echo "Waiting 15 seconds for backend to be ready..."
sleep 15

# ------------------------------
# 5. Deploy contracts to backend
# ------------------------------
echo "=========================================="
echo "Deploying contracts..."
echo "=========================================="
docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# ------------------------------
# 6. Start frontend container
# ------------------------------
echo "=========================================="
echo "Starting frontend container..."
echo "=========================================="
docker compose up -d frontend

# ------------------------------
# 7. Show container status
# ------------------------------
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo "=========================================="
echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
echo "=========================================="
