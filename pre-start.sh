#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: installing dependencies, compiling contracts and exporting ABIs..."
echo "=========================================="

# ------------------------------
# 1. Install backend dependencies (exact versions)
# ------------------------------
echo "[INFO] Installing backend dependencies..."
cd backend
npm ci   # forces exact versions from package-lock.json
cd ..

# ------------------------------
# 2. Install frontend dependencies (exact versions)
# ------------------------------
echo "[INFO] Installing frontend dependencies..."
cd frontend
npm ci
cd ..

# ------------------------------
# 3. Compile Hardhat contracts
# ------------------------------
echo "[INFO] Compiling contracts..."
cd backend
npx hardhat compile
cd ..

# ------------------------------
# 4. Export ABIs to frontend
# ------------------------------
echo "[INFO] Exporting ABIs to frontend..."
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"
mkdir -p $FRONTEND_CONTRACT_DIR

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/Governance.sol/Governance.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/Treasury.sol/Treasury.json $FRONTEND_CONTRACT_DIR/
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json $FRONTEND_CONTRACT_DIR/

echo "[OK] Pre-start completed. ABIs exported to frontend."
