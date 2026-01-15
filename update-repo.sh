#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 2.x repo cleanup workflow"
echo "=========================================="

# ----------------------------
# 1. Remove legacy Hardhat 3.x files
# ----------------------------
echo "[INFO] Removing legacy Hardhat 3.x config files..."
rm -f hardhat.config.js package.json package-lock.json
rm -rf node_modules

# ----------------------------
# 2. Backend cleanup and HH2.x install
# ----------------------------
BACKEND_DIR="./backend"
echo "[INFO] Cleaning backend..."
cd "$BACKEND_DIR"

rm -rf node_modules

# Ensure package-lock.json exists for npm ci
if [ ! -f package-lock.json ]; then
    echo "[INFO] package-lock.json missing. Generating it..."
    npm install
fi

echo "[INFO] Installing deterministic Hardhat 2.x dependencies..."
npm ci

# ----------------------------
# 3. Compile contracts
# ----------------------------
echo "[INFO] Compiling Hardhat contracts..."
npx hardhat compile

# ----------------------------
# 4. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="../frontend/src/contracts"
mkdir -p "$FRONTEND_CONTRACT_DIR"

echo "[INFO] Exporting ABIs to frontend..."
cp artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[INFO] Backend update complete!"
cd -

# ----------------------------
# 5. Frontend cleanup & install
# ----------------------------
FRONTEND_DIR="./frontend"
echo "[INFO] Cleaning frontend..."
cd "$FRONTEND_DIR"

rm -rf node_modules

# Ensure frontend package-lock exists
if [ ! -f package-lock.json ]; then
    echo "[INFO] Frontend package-lock.json missing. Generating it..."
    npm install
fi

echo "[INFO] Installing frontend dependencies..."
npm ci

cd -

echo "=========================================="
echo "Repo update for Hardhat 2.x complete!"
echo "You can now run ./pre-start.sh and ./start.sh"
echo "=========================================="
