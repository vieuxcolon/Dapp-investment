
#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp (standalone)"
echo "=========================================="

# ----------------------------
# 1. Backend: build & start container
# ----------------------------
echo "=========================================="
echo "Building and starting backend container..."
echo "=========================================="

docker compose build --no-cache backend
docker compose up -d backend

# Wait for Hardhat node to initialize
echo "[INFO] Waiting 15 seconds for backend to initialize..."
sleep 15

# ----------------------------
# 2. Deploy contracts (if not already deployed)
# ----------------------------
echo "=========================================="
echo "Deploying contracts..."
echo "=========================================="

docker compose run --rm backend npx hardhat run scripts/deploy.js --network localhost

# ----------------------------
# 3. Frontend: build & start container
# ----------------------------
echo "=========================================="
echo "Building and starting frontend container..."
echo "=========================================="

docker compose build --no-cache frontend
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
