#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Run pre-start.sh
./pre-start.sh

# Step 2: Build & start backend container
echo "=========================================="
echo "Building backend container..."
echo "=========================================="
docker compose build --no-cache backend
docker compose up -d backend

# Wait for backend Hardhat node to initialize
echo "[INFO] Waiting 15 seconds for backend RPC node..."
sleep 15

# Step 3: Deploy contracts and update .env
echo "=========================================="
echo "Deploying contracts..."
echo "=========================================="
docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# Step 4: Build & start frontend container
echo "=========================================="
echo "Building frontend container..."
echo "=========================================="
docker compose build --no-cache frontend
docker compose up -d frontend

# Step 5: Show status
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo "=========================================="
echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
