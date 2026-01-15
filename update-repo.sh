#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

# 1️⃣ Backup existing config and package files
BACKUP_DIR="backup_hh2_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "[INFO] Backing up package.json and package-lock.json to $BACKUP_DIR..."
for f in package.json package-lock.json hardhat.config.js; do
    if [ -f "$f" ]; then
        cp "$f" "$BACKUP_DIR/"
        echo "[INFO] Backed up $f"
    else
        echo "[WARN] $f not found, skipping backup."
    fi
done

# 2️⃣ Clean node_modules and previous lockfile
echo "[INFO] Cleaning backend node_modules and package-lock.json..."
rm -rf node_modules package-lock.json

# 3️⃣ Install Hardhat 3.x and Toolbox + necessary plugins
echo "[INFO] Installing Hardhat 3.x and Toolbox with compatible plugins..."
npm install --save-dev \
  hardhat@3.1.4 \
  @nomicfoundation/hardhat-toolbox@3.0.0 \
  @nomicfoundation/hardhat-ethers@3.1.3 \
  @nomicfoundation/hardhat-chai-matchers@3.0.0 \
  --legacy-peer-deps

# 4️⃣ Generate new hardhat.config.js if not present
if [ ! -f hardhat.config.js ]; then
    echo "[INFO] Creating new hardhat.config.js for Hardhat 3.x..."
    npx hardhat init --force --no-interactive
else
    echo "[INFO] Existing hardhat.config.js found, skipping init."
fi

# 5️⃣ Compile contracts
echo "[INFO] Compiling contracts with Hardhat 3.x..."
npx hardhat compile

echo "=========================================="
echo "Hardhat 3.x upgrade workflow complete."
echo "=========================================="
