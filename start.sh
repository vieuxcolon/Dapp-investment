#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Run pre-start.sh
./pre-start.sh

# Step 2: Start Docker containers via docker-compose
echo "=========================================="
echo "Building and starting Docker containers..."
echo "=========================================="

# Use Docker Compose v2+ syntax
docker compose up --build -d

# Step 3: Show container status
echo "=========================================="
echo "Containers status:"
docker ps --filter "name=dao-"

echo "DApp started successfully!"
echo "Frontend: http://localhost:3000"
echo "Backend Hardhat Node RPC: http://localhost:8545"
