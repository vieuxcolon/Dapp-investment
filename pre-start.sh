#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: validating, compiling, exporting ABIs"
echo "=========================================="

# ----------------------------
# 1. Backend dependencies
# ----------------------------
BACKEND_DIR="./backend"
cd "$BACKEND_DIR"

echo "[INFO] Installing deterministic backend dependencies via package-lock.json..."
# Install exactly what's in package-lock.json
npm ci

# ----------------------------
# 2. Compile contracts
# ----------------------------
echo "[INFO] Compiling Hardhat contracts..."
npx hardhat compile

cd - >/dev/null

# ----------------------------
# 3. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"
mkdir -p "$FRONTEND_CONTRACT_DIR"

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[OK] ABIs exported to frontend."
