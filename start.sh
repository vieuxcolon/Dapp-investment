#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Compile contracts and export ABIs
echo "Step 1: Pre-start (compile contracts & export ABIs)"
./pre-start.sh

# Step 2: Build and start Docker containers
echo "Step 2: Build & start Docker containers"
docker compose up --build -d

# Step 3: Wait a few seconds for Hardhat node to be ready
echo "Waiting 15 seconds for Hardhat node to start..."
sleep 15

# Step 4: Deploy contracts
echo "Step 3: Deploy contracts to local Hardhat node"
docker compose exec backend npx hardhat run scripts/deploy.js --network localhost

# Step 5: Show container status
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo "=========================================="
echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
