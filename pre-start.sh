#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: installing dependencies, compiling contracts and exporting ABIs..."
echo "=========================================="

# ----------------------------
# 1. Backend dependencies
# ----------------------------
BACKEND_DIR="./backend"
cd "$BACKEND_DIR"

echo "[INFO] Ensuring deterministic backend dependencies..."

# Force Hardhat 3.3.0
npm install --save-dev hardhat@3.3.0

# Force compatible Hardhat toolbox
npm install @nomicfoundation/hardhat-toolbox@6.1.2 --save-dev

# Ensure package-lock.json exists
if [ ! -f package-lock.json ]; then
  echo "[INFO] package-lock.json missing. Running npm install to generate lockfile..."
  npm install --package-lock-only
fi

# Compile contracts
npx hardhat compile

cd - >/dev/null

# ----------------------------
# 2. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"
mkdir -p "$FRONTEND_CONTRACT_DIR"

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[OK] ABIs exported to frontend."
