#!/bin/bash
set -e

REQUIRED_NODE_MAJOR=22
REQUIRED_NODE_VERSION="22.10.0"

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

# ----------------------------
# 1. Check for other apt/dpkg processes
# ----------------------------
echo "[INFO] Checking for other apt/dpkg processes..."
sudo fuser -v /var/lib/dpkg/lock || true
sudo rm -f /var/lib/dpkg/lock
sudo dpkg --configure -a
echo "[INFO] apt/dpkg locks cleared. Continuing..."

# ----------------------------
# 2. Check Node.js
# ----------------------------
if command -v node &>/dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//')
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)
    echo "[INFO] Node.js version detected: $NODE_VERSION"

    if [ "$NODE_MAJOR" -lt "$REQUIRED_NODE_MAJOR" ]; then
        echo "[WARN] Node.js version is too old. Removing current version..."
        sudo apt remove -y nodejs
        sudo apt autoremove -y
        INSTALL_NODE=true
    else
        echo "[OK] Node.js version is sufficient."
        INSTALL_NODE=false
    fi
else
    echo "[WARN] Node.js not found. Will install required version."
    INSTALL_NODE=true
fi

if [ "$INSTALL_NODE" = true ]; then
    echo "[INFO] Installing Node.js $REQUIRED_NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
fi

echo "[INFO] Node.js version now: $(node -v)"
echo "[INFO] npm version: $(npm -v)"

# ----------------------------
# 3. Check npm
# ----------------------------
if ! command -v npm &>/dev/null; then
    echo "[INFO] npm not found. Installing..."
    sudo apt install -y npm
else
    echo "[OK] npm detected: $(npm -v)"
fi

# ----------------------------
# 4. Check npx
# ----------------------------
if ! command -v npx &>/dev/null; then
    echo "[INFO] npx not found. Installing..."
    sudo npm install -g npx
else
    echo "[OK] npx detected: $(npx -v)"
fi

# ----------------------------
# 5. Check Docker
# ----------------------------
if command -v docker &>/dev/null; then
    echo "[OK] Docker version $(docker --version) detected"
else
    echo "[WARN] Docker not found. Please install Docker."
fi

# ----------------------------
# 6. Check Docker Compose
# ----------------------------
if command -v docker-compose &>/dev/null || command -v docker compose &>/dev/null; then
    echo "[OK] Docker Compose detected"
else
    echo "[WARN] Docker Compose not found. Please install Docker Compose."
fi

# ----------------------------
# 7. Check Hardhat listed in backend/package.json
# ----------------------------
if [ -f "backend/package.json" ]; then
    if grep -q '"hardhat"' backend/package.json; then
        echo "[OK] Hardhat already listed in backend/package.json"
    else
        echo "[WARN] Hardhat not listed in backend/package.json"
    fi
else
    echo "[WARN] backend/package.json not found"
fi

echo "=========================================="
echo "Host environment remediation complete!"
echo "You should now be able to run ./pre-start.sh and ./start.sh"
echo "=========================================="
