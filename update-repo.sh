#!/bin/bash
# update-repo.sh — Hardhat 3.x upgrade workflow

set -e

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

# Backup existing files
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="backup_hh2_$TIMESTAMP"
echo "[INFO] Backing up old Hardhat 2.x files to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r contracts hardhat.config.js package*.json "$BACKUP_DIR" || echo "[WARN] Some files not found to backup."

# Clean old node_modules and package-lock
echo "[INFO] Cleaning backend node_modules and package-lock..."
rm -rf node_modules package-lock.json

# Hardhat 3.x versions
HH_VERSION="3.1.4"
TOOLBOX_VERSION="3.1.0"

echo "[INFO] Installing Hardhat 3.x and Toolbox..."
# --legacy-peer-deps avoids npm dependency conflicts
npm install --save-dev hardhat@"$HH_VERSION" \
    @nomicfoundation/hardhat-toolbox@"$TOOLBOX_VERSION" --legacy-peer-deps

# Optionally install other plugins compatible with HH 3.x
# npm install --save-dev @nomicfoundation/hardhat-ethers@"^3.0.0" --legacy-peer-deps

echo "[INFO] Creating new Hardhat 3.x config..."
cat > hardhat.config.js <<EOL
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    hardhat: {},
  }
};
EOL

echo "[INFO] Compiling contracts with Hardhat 3.x..."
npx hardhat compile

echo "[INFO] Hardhat 3.x upgrade workflow completed successfully!"
