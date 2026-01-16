#!/bin/bash
# update-repo.sh
# ================================
# Updates backend repository dependencies and Hardhat 3.x setup
# ================================

set -e

echo "=========================================="
echo "Update Repo Script - Backend"
echo "=========================================="

# -------------------------
# 1. Backup package files
# -------------------------
BACKUP_DIR="backup_hh2_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

for FILE in package.json package-lock.json hardhat.config.js; do
  if [ -f "$FILE" ]; then
    cp "$FILE" "$BACKUP_DIR/"
    echo "[OK] Backed up $FILE to $BACKUP_DIR/"
  fi
done

# -------------------------
# 2. Clean node_modules
# -------------------------
echo "[INFO] Removing old node_modules and package-lock.json"
rm -rf node_modules package-lock.json

# -------------------------
# 3. Install Hardhat 3.x & plugins
# -------------------------
echo "[INFO] Installing Hardhat 3.x with compatible plugins"
npm install --save-dev \
  hardhat@3.1.4 \
  @nomicfoundation/hardhat-toolbox@3.0.0 \
  @nomicfoundation/hardhat-ethers@3.1.3 \
  @nomicfoundation/hardhat-chai-matchers@2.1.2 \
  chai@^4.2.0 \
  --legacy-peer-deps

echo "[OK] Hardhat 3.x and plugins installed successfully"

# -------------------------
# 4. Ensure hardhat.config.js exists
# -------------------------
if [ ! -f hardhat.config.js ]; then
  echo "[WARN] hardhat.config.js not found. Creating default config..."
  cat > hardhat.config.js <<EOL
import "@nomicfoundation/hardhat-toolbox";

/** @type import('hardhat/config').HardhatUserConfig */
const config = {
  solidity: "0.8.20",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};

export default config;
EOL
  echo "[OK] Default hardhat.config.js created"
else
  echo "[OK] hardhat.config.js already exists"
fi

echo "=========================================="
echo "Backend repo updated successfully!"
echo "=========================================="
