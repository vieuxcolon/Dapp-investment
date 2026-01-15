#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# ----------------------------
# 1. Run pre-start (install + compile + export ABIs)
# ----------------------------
./pre-start.sh

# ----------------------------
# 2. Build & start backend container
# ----------------------------
echo "=========================================="
echo "Building and starting backend container..."
docker compose build --no-cache backend
docker compose up -d backend

echo "[INFO] Waiting 15 seconds for backend to initialize..."
sleep 15

# ----------------------------
# 3. Deploy contracts via Hardhat
# ----------------------------
echo "=========================================="
echo "Deploying contracts..."
docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# ----------------------------
# 4. Build & start frontend container
# ----------------------------
echo "=========================================="
echo "Building and starting frontend container..."
docker compose build --no-cache frontend
docker compose up -d frontend

# ----------------------------
# 5. Show container status
# ----------------------------
echo "=========================================="
docker ps --filter "name=dao-"

echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"

