#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# REAL-TIME ATTACK GENERATOR STARTER
# =========================================================

set -e

echo "================================================="
echo "      SOC-IAC ATTACK GENERATOR STARTING"
echo "================================================="

# =========================================================
# MOVE TO PROJECT ROOT
# =========================================================

cd "$(dirname "$0")/.."

# =========================================================
# CREATE LOG DIRECTORY
# =========================================================

echo "[+] Checking simulated_logs directory..."

mkdir -p simulated_logs

# =========================================================
# CREATE LOG FILES IF MISSING
# =========================================================

touch simulated_logs/attacks.json
touch simulated_logs/auth_events.json
touch simulated_logs/network_events.json
touch simulated_logs/dns_events.json

# =========================================================
# PERMISSIONS
# =========================================================

chmod 644 simulated_logs/*.json

# =========================================================
# PYTHON CHECK
# =========================================================

if ! command -v python3 &> /dev/null
then
    echo "[ERROR] Python3 is not installed."
    exit 1
fi

# =========================================================
# DISPLAY INFO
# =========================================================

echo ""
echo "================================================="
echo "           ATTACK GENERATOR INFO"
echo "================================================="
echo ""

echo "[+] Generator file : attack_generator/generator.py"
echo "[+] Output logs    : simulated_logs/"
echo "[+] Event interval : 3 seconds"

echo ""

# =========================================================
# START GENERATOR
# =========================================================

echo "[+] Starting generator..."

python3 attack_generator/generator.py