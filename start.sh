#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Run pre-start.sh (compile + export ABIs)
./pre-start.sh

# Step 2: Start backend Hardhat node
echo "=========================================="
echo "Starting backend Hardhat node..."
echo "=========================================="

docker compose up -d backend

# Wait a few seconds to ensure Hardhat node is ready
echo "Waiting 5 seconds for backend to initialize..."
sleep 5

# Step 3: Deploy contracts and update .env files
echo "=========================================="
echo "Deploying contracts..."
echo "=========================================="

docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# Step 4: Start frontend container
echo "=========================================="
echo "Starting frontend container..."
echo "=========================================="

docker compose up -d frontend

# Step 5: Show status
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo " DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
