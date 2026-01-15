#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Ensure scripts are executable
chmod +x pre-start.sh

echo "Running pre-start checks (compile & export ABIs)..."
./pre-start.sh

echo "Building Docker containers..."
docker-compose build

echo "Starting backend (Hardhat node)..."
docker-compose up -d backend

# Wait for Hardhat node to be ready
echo "Waiting for Hardhat node to initialize..."
sleep 6

# Get backend container ID safely
BACKEND_CONTAINER=$(docker ps -qf "name=dapp-investment_backend")

if [ -z "$BACKEND_CONTAINER" ]; then
  echo "Backend container not found. Aborting."
  exit 1
fi

echo "Deploying smart contracts to local Hardhat network..."
docker exec -it "$BACKEND_CONTAINER" npx hardhat run scripts/deploy.js --network localhost

echo "Starting frontend (React app)..."
docker-compose up -d frontend

echo "=========================================="
echo "Investment DAO DApp is now running!"
echo ""
echo "Frontend: http://localhost:3000"
echo "Backend (Hardhat): http://localhost:8545"
echo ""
echo "   Next steps:"
echo "   1. Open MetaMask"
echo "   2. Add local network (RPC: http://localhost:8545, Chain ID: 31337)"
echo "   3. Import a Hardhat test account"
echo "=========================================="
