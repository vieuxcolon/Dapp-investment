#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 2.x repo cleanup workflow"
echo "=========================================="

# ----------------------------
# 1. Remove HH3.x root-level files
# ----------------------------
echo "[INFO] Removing legacy HH3.x files..."
rm -f hardhat.config.js package.json package-lock.json
rm -rf node_modules

# ----------------------------
# 2. Clean backend
# ----------------------------
echo "[INFO] Cleaning backend..."
cd backend
rm -rf node_modules package-lock.json
echo "[INFO] Installing deterministic HH2.x dependencies..."
npm ci   # installs versions in backend/package.json
cd -

# ----------------------------
# 3. Compile contracts & export ABIs
# ----------------------------
echo "[INFO] Compiling contracts and updating frontend ABIs..."
cd backend
npx hardhat compile
mkdir -p ../frontend/src/contracts
cp artifacts/contracts/*.json ../frontend/src/contracts/
cd -

# ----------------------------
# 4. Stage only HH2.x aligned files
# ----------------------------
echo "[INFO] Staging files for commit..."
git add backend/package.json backend/package-lock.json backend/hardhat.config.js
git add backend/contracts backend/scripts backend/test
git add frontend/src/contracts frontend/src/contracts-address.json
git add pre-check.sh pre-start.sh start.sh

# ----------------------------
# 5. Remove HH3.x leftovers from Git
# ----------------------------
echo "[INFO] Removing HH3.x obsolete files from Git..."
git rm -f hardhat.config.js package.json package-lock.json || true

# ----------------------------
# 6. Commit the clean HH2.x repo
# ----------------------------
echo "[INFO] Committing changes..."
git commit -m "Cleanup: remove HH3.x files, align repo with Hardhat 2.x"

# ----------------------------
# 7. Verify
# ----------------------------
echo "[INFO] Verifying Hardhat version..."
cd backend
npx hardhat --version  # should print 2.28.x
cd -

echo "=========================================="
echo "Hardhat 2.x cleanup complete. Ready to push to remote."
echo "=========================================="
