#!/bin/bash
set -e

echo "=== Automated DApp Build + Deployment (Ready-to-Interact) ==="

# --- Setup Hardhat node ---
echo "[Hardhat] Starting local chain with pre-funded accounts..."
cd /workspace/contracts

# Ensure Hardhat dependencies
npm install

# Start Hardhat node in background with 10 accounts preloaded
npx hardhat node --hostname 0.0.0.0 --port 8545 --accounts 10 & 
HARDHAT_PID=$!
sleep 5

# --- Deploy contracts ---
echo "[Contracts] Deploying contracts..."
npx hardhat run scripts/deploy.ts --network localhost
echo "[Contracts] Deployment done."

# --- Export addresses for backend/frontend ---
cp ./deployments/addresses.json /workspace/contracts/deployments/addresses.json

# --- Set environment variables for backend/frontend ---
export REACT_APP_CONTRACTS_JSON=/workspace/contracts/deployments/addresses.json
export BACKEND_CONTRACTS_JSON=/workspace/contracts/deployments/addresses.json
export HARDHAT_RPC=http://localhost:8545

# --- Backend build ---
if [ -d "/workspace/backend" ]; then
    echo "[Backend] Installing dependencies..."
    cd /workspace/backend
    npm install
    npx tsc
    echo "[Backend] Build done."
fi

# --- Frontend build ---
if [ -d "/workspace/frontend" ]; then
    echo "[Frontend] Installing dependencies..."
    cd /workspace/frontend
    npm install
    npm run build
    echo "[Frontend] Build done."
fi

echo "=== All builds completed! ==="
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:4000"
echo "Hardhat RPC: http://localhost:8545"

# Keep container alive for testing
tail -f /dev/null
