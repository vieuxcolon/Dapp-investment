#!/bin/bash
set -e

echo "=========================================="
echo "Verifying and remediating host environment"
echo "=========================================="

# ------------------------------
# 1. Handle hung apt/dpkg locks
# ------------------------------
MAX_WAIT=120  # seconds
WAITED=0
SLEEP_INTERVAL=5

echo "[INFO] Checking for other apt/dpkg processes..."

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "[WARNING] apt/dpkg lock has been held for over $MAX_WAIT seconds."
        echo "[INFO] Attempting to detect stuck processes..."
        STUCK_PIDS=$(ps -eo pid,cmd | grep -E "apt|dpkg" | grep -v grep | awk '{print $1}')
        if [ -n "$STUCK_PIDS" ]; then
            echo "[INFO] Stopping stuck processes: $STUCK_PIDS"
            sudo kill -9 $STUCK_PIDS
            echo "[INFO] Removing lock files..."
            sudo rm -f /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock
            sudo dpkg --configure -a
        fi
        break
    fi
    echo "[INFO] Waiting for other apt/dpkg processes to finish..."
    sleep $SLEEP_INTERVAL
    WAITED=$((WAITED + SLEEP_INTERVAL))
done

echo "[INFO] apt/dpkg locks cleared. Continuing..."

# ------------------------------
# 2. Install / verify Node.js v20
# ------------------------------
NODE_REQUIRED="20"

if command -v node >/dev/null 2>&1; then
    NODE_CURRENT=$(node -v | sed 's/v//;s/\..*//')
    if [ "$NODE_CURRENT" -eq "$NODE_REQUIRED" ]; then
        echo "[OK] Node.js v$NODE_REQUIRED detected"
    else
        echo "[WARNING] Node.js v$(node -v) detected, but v$NODE_REQUIRED.x is required."
        echo "[INFO] Installing Node.js v$NODE_REQUIRED..."
        sudo apt remove -y nodejs
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
else
    echo "[INFO] Node.js not found. Installing Node.js v$NODE_REQUIRED..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# ------------------------------
# 3. Verify npm and npx
# ------------------------------
if command -v npm >/dev/null 2>&1; then
    echo "[OK] npm $(npm -v) detected"
else
    echo "[INFO] Installing npm..."
    sudo apt install -y npm
fi

if command -v npx >/dev/null 2>&1; then
    echo "[OK] npx $(npx -v) detected"
else
    echo "[INFO] Installing npx..."
    sudo npm install -g npx
fi

# ------------------------------
# 4. Verify Hardhat
# ------------------------------
if [ -f "./backend/package.json" ] && grep -q "hardhat" ./backend/package.json; then
    echo "[OK] Hardhat already listed in backend/package.json"
else
    echo "[INFO] Installing Hardhat in backend..."
    cd backend
    npm install --save-dev hardhat
    cd ..
fi

# ------------------------------
# 5. Verify Docker and Docker Compose
# ------------------------------
if command -v docker >/dev/null 2>&1; then
    echo "[OK] Docker $(docker --version) detected"
else
    echo "[INFO] Docker not found. Please install Docker manually: https://docs.docker.com/get-docker/"
fi

if command -v docker-compose >/dev/null 2>&1 || docker compose version >/dev/null 2>&1; then
    echo "[OK] Docker Compose detected"
else
    echo "[INFO] Docker Compose not found. Please install Docker Compose: https://docs.docker.com/compose/install/"
fi

echo "=========================================="
echo "Host environment remediation complete!"
echo "You should now be able to run ./pre-start.sh"
echo "=========================================="
