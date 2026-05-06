#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# CLEANUP SCRIPT
# =========================================================

set -e

echo "================================================="
echo "            SOC-IAC CLEANUP"
echo "================================================="

# =========================================================
# CONFIRMATION
# =========================================================

echo ""
echo "[WARNING] This will:"
echo "  - Stop Docker containers"
echo "  - Remove containers"
echo "  - Remove generated logs"
echo "  - Remove temporary files"
echo "  - Clean Elasticsearch data (optional)"
echo ""

read -p "Continue? (y/N): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]
then
    echo "[INFO] Cleanup cancelled."
    exit 0
fi

# =========================================================
# STOP CONTAINERS
# =========================================================

echo ""
echo "[+] Stopping Docker containers..."

docker compose down

# =========================================================
# REMOVE GENERATED LOGS
# =========================================================

echo ""
echo "[+] Cleaning simulated logs..."

find simulated_logs -type f -name "*.json" -exec truncate -s 0 {} \;

# =========================================================
# REMOVE TEMP FILES
# =========================================================

echo ""
echo "[+] Removing temporary files..."

find . -type f -name "*.log" -delete || true
find . -type f -name "*.tmp" -delete || true
find . -type f -name "*.pid" -delete || true

# =========================================================
# REMOVE PYTHON CACHE
# =========================================================

echo ""
echo "[+] Removing Python cache..."

find . -type d -name "__pycache__" -exec rm -rf {} + || true
find . -type f -name "*.pyc" -delete || true

# =========================================================
# OPTIONAL ELASTICSEARCH DATA CLEANUP
# =========================================================

echo ""
read -p "Remove Elasticsearch volumes/data? (y/N): " REMOVE_ES

if [[ "$REMOVE_ES" == "y" || "$REMOVE_ES" == "Y" ]]
then

    echo ""
    echo "[+] Removing Docker volumes..."

    docker compose down -v

    echo "[OK] Elasticsearch volumes removed."

fi

# =========================================================
# FINAL STATUS
# =========================================================

echo ""
echo "================================================="
echo " CLEANUP FINISHED"
echo "================================================="

echo ""
echo "[INFO] SOC environment cleaned successfully."