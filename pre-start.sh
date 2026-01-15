#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: installing dependencies, compiling contracts and exporting ABIs..."
echo "=========================================="

# ------------------------------
# 0. Backend setup
# ------------------------------
cd backend

if [ ! -f package-lock.json ]; then
  echo "[INFO] No package-lock.json found in backend. Running npm install to generate lockfile..."
  npm install
fi

echo "[INFO] Installing backend dependencies deterministically..."
npm ci

# ------------------------------
# 1. Compile contracts
# ------------------------------
npx hardhat compile

cd ..

# ------------------------------
# 2. Frontend setup
# ------------------------------
cd frontend

if [ ! -f package-lock.json ]; then
  echo "[INFO] No package-lock.json found in frontend. Running npm install to generate lockfile..."
  npm install
fi

echo "[INFO] Installing frontend dependencies deterministically..."
npm ci

cd ..

# ------------------------------
# 3. Export ABIs from backend to frontend
# ------------------------------
FRONTEND_CONTRACT_DIR="frontend/src/contracts"
mkdir -p $FRONTEND_CONTRACT_DIR

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/Governance.sol/Governance.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/Treasury.sol/Treasury.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json $FRONTEND_CONTRACT_DIR/

echo "[INFO] ABIs exported to frontend."

echo "=========================================="
echo "Pre-start complete. Backend and frontend ready."
echo "=========================================="
