#!/bin/bash
set -e

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

REQUIRED_NODE_VERSION=20
HARDHAT_VERSION=3.2.0

# -----------------------------
# Helper: wait for apt lock
# -----------------------------
wait_for_apt() {
    while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
          sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
        echo "[INFO] Waiting for other apt/dpkg processes to finish..."
        sleep 5
    done
}

# -----------------------------
# 1. Node.js & npm
# -----------------------------
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//' | cut -d '.' -f1)
    if [ "$NODE_VERSION" -eq "$REQUIRED_NODE_VERSION" ]; then
        echo "[OK] Node.js v$NODE_VERSION detected"
    else
        echo "[WARNING] Node.js v$NODE_VERSION detected, but v$REQUIRED_NODE_VERSION.x required."
        echo "[INFO] Installing Node.js v$REQUIRED_NODE_VERSION..."
        wait_for_apt
        sudo apt-get remove -y nodejs npm || true
        curl -fsSL https://deb.nodesource.com/setup_${REQUIRED_NODE_VERSION}.x | sudo -E bash -
        wait_for_apt
        sudo apt-get install -y nodejs
    fi
else
    echo "[ERROR] Node.js not detected. Installing Node.js v$REQUIRED_NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_${REQUIRED_NODE_VERSION}.x | sudo -E bash -
    wait_for_apt
    sudo apt-get install -y nodejs
fi

# Verify installation
NODE_VERSION_INSTALLED=$(node -v | sed 's/v//' | cut -d '.' -f1)
echo "[OK] Node.js v$NODE_VERSION_INSTALLED installed"

# npm & npx
if command -v npm &> /dev/null; then
    echo "[OK] npm $(npm -v) detected"
else
    echo "[INFO] Installing npm..."
    wait_for_apt
    sudo apt-get install -y npm
fi

if command -v npx &> /dev/null; then
    echo "[OK] npx $(npx -v) detected"
else
    echo "[INFO] Installing npx..."
    sudo npm install -g npx
fi

# -----------------------------
# 2. Hardhat
# -----------------------------
if [ -f backend/package.json ]; then
    if grep -q '"hardhat"' backend/package.json; then
        echo "[OK] Hardhat listed in backend/package.json"
    else
        echo "[WARNING] Hardhat not found in backend/package.json. Installing..."
        cd backend
        npm install --save-dev hardhat@$HARDHAT_VERSION
        cd ..
        echo "[OK] Hardhat installed (v$HARDHAT_VERSION) in backend"
    fi
else
    echo "[ERROR] backend/package.json not found. Cannot verify Hardhat."
fi

# -----------------------------
# 3. Docker & Docker Compose
# -----------------------------
if command -v docker &> /dev/null; then
    echo "[OK] Docker $(docker --version) detected"
else
    echo "[ERROR] Docker not installed. Install from https://docs.docker.com/get-docker/"
fi

if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    echo "[OK] Docker Compose detected"
else
    echo "[ERROR] Docker Compose not installed. Install from https://docs.docker.com/compose/install/"
fi

echo "=========================================="
echo "Host environment verification/remediation complete!"
echo "You should now be able to run ./pre-start.sh and ./start.sh successfully."
echo "=========================================="
