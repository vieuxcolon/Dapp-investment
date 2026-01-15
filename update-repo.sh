#!/bin/bash
set -e

echo "=========================================="
echo "Starting Hardhat 3.x repo upgrade workflow"
echo "=========================================="

TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="backup_hh2_$TIMESTAMP"

# --- Step 1: Backup old HH2.x files ---
echo "[INFO] Backing up old Hardhat 2.x files to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

for FILE in contracts hardhat.config.js package.json package-lock.json; do
    if [ -e "$FILE" ]; then
        cp -r "$FILE" "$BACKUP_DIR/"
        echo "[INFO] Backed up $FILE"
    else
        echo "[WARN] $FILE not found, skipping backup."
    fi
done

# --- Step 2: Clean node_modules and package-lock ---
echo "[INFO] Cleaning backend node_modules and package-lock..."
rm -rf node_modules package-lock.json

# --- Step 3: Install Hardhat 3.x and Toolbox ---
HH_VERSION="3.1.4"
TOOLBOX_VERSION="3.0.0"

echo "[INFO] Installing Hardhat $HH_VERSION and Toolbox $TOOLBOX_VERSION..."
npm install --save-dev hardhat@"$HH_VERSION" \
    @nomicfoundation/hardhat-toolbox@"$TOOLBOX_VERSION" --legacy-peer-deps

# --- Step 4: Create a new Hardhat 3.x config if missing ---
if [ ! -f hardhat.config.js ]; then
    echo "[INFO] Creating new hardhat.config.js for HH3.x..."
    npx hardhat init --force
else
    echo "[INFO] hardhat.config.js already exists, skipping creation."
fi

# --- Step 5: Compile contracts ---
echo "[INFO] Compiling contracts with Hardhat 3.x..."
npx hardhat compile

echo "=========================================="
echo "Hardhat 3.x upgrade workflow completed!"
echo "Backup of HH2.x files: $BACKUP_DIR"
echo "=========================================="
