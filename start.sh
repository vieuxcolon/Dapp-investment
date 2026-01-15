#!/bin/bash
set -e

echo "=========================================="
echo "Starting Investment DAO DApp"
echo "=========================================="

# Step 1: Build Docker images
echo "Step 1: Building backend and frontend Docker images..."
docker compose build --no-cache

# Step 2: Start backend container (Hardhat node)
echo "Step 2: Starting backend container..."
docker compose up -d backend

# Wait for Hardhat node
echo "Waiting 5 seconds for Hardhat node..."
sleep 15

# Step 3: Compile contracts & export ABIs
echo "Step 3: Compiling contracts and exporting ABIs..."
./pre-start.sh

# Step 4: Start frontend container
echo "Step 4: Starting frontend container..."
docker compose up -d frontend

echo "=========================================="
echo " All services are running!"
echo "Frontend: http://localhost:3000"
echo "Hardhat node RPC: http://localhost:8545"
echo "=========================================="
