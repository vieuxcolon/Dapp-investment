#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: validating, compiling, exporting ABIs"
echo "=========================================="

# ----------------------------
# 1. Backend validation
# ----------------------------
BACKEND_DIR="./backend"

if [ ! -f "$BACKEND_DIR/package.json" ]; then
  echo "[ERROR] backend/package.json not found"
  exit 1
fi

if [ ! -f "$BACKEND_DIR/package-lock.json" ]; then
  echo "[ERROR] backend/package-lock.json missing"
  echo "        Run npm install ONCE manually in backend/"
  exit 1
fi

echo "[OK] Backend package.json and package-lock.json found"

# ----------------------------
# 2. Compile contracts (host)
# ----------------------------
cd "$BACKEND_DIR"

echo "[INFO] Installing dependencies deterministically (npm ci)..."
npm ci

echo "[INFO] Compiling contracts..."
npx hardhat compile

cd - >/dev/null

# ----------------------------
# 3. Export ABIs to frontend
# ----------------------------
FRONTEND_CONTRACT_DIR="./frontend/src/contracts"

echo "[INFO] Exporting ABIs to frontend..."
mkdir -p "$FRONTEND_CONTRACT_DIR"

cp backend/artifacts/contracts/DAOToken.sol/DAOToken.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Governance.sol/Governance.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/Treasury.sol/Treasury.json "$FRONTEND_CONTRACT_DIR/"
cp backend/artifacts/contracts/ProposalExecutor.sol/ProposalExecutor.json "$FRONTEND_CONTRACT_DIR/"

echo "[OK] ABIs exported successfully"
echo "=========================================="
