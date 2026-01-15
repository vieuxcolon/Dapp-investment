#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# ----------------------------
# 1. Build & start backend container
# ----------------------------
echo "=========================================="
echo "Building and starting backend container..."
echo "=========================================="

docker compose build --no-cache backend
docker compose up -d backend

echo "[INFO] Waiting 15 seconds for backend to initialize..."
sleep 15

# ----------------------------
# 2. Deploy contracts
# ----------------------------
echo "=========================================="
echo "Deploying contracts..."
echo "=========================================="

docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# ----------------------------
# 3. Start frontend container
# ----------------------------
echo "=========================================="
echo "Starting frontend container..."
echo "=========================================="

docker compose build frontend
docker compose up -d frontend

# ----------------------------
# 4. Show container status
# ----------------------------
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo "=========================================="
echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
