#!/bin/bash
set -e

echo "=========================================="
echo "Pre-start: validating, compiling, exporting ABIs"
echo "=========================================="

BACKEND_DIR="./backend"
FRONTEND_DIR="./frontend/src/contracts"

# ----------------------------
# 1. Backend dependencies (deterministic)
# ----------------------------
cd "$BACKEND_DIR"
echo "[INFO] Installing deterministic dependencies..."
npm ci

# ----------------------------
# 2. Compile Hardhat contracts
# ----------------------------
echo "[INFO] Compiling contracts..."
npx hardhat clean
npx hardhat compile

cd - >/dev/null

# ----------------------------
# 3. Export ABIs
# ----------------------------
mkdir -p "$FRONTEND_DIR"
for contract in DAOToken Governance Treasury ProposalExecutor; do
    src="$BACKEND_DIR/artifacts/contracts/$contract.sol/$contract.json"
    if [ -f "$src" ]; then
        cp "$src" "$FRONTEND_DIR/"
        echo "[INFO] Exported $contract ABI to frontend"
    else
        echo "[WARN] $contract artifact not found, skipping..."
    fi
done

echo "[OK] Pre-start phase complete."
