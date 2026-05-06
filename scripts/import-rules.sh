#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# KIBANA RULE IMPORTER
# =========================================================

set -e

echo "================================================="
echo "         KIBANA RULE IMPORTER"
echo "================================================="

# =========================================================
# CONFIGURATION
# =========================================================

KIBANA_URL="http://localhost:5601"

RULES_DIR="detection-rules/kibana"

# =========================================================
# CHECK KIBANA
# =========================================================

echo "[+] Checking Kibana availability..."

if ! curl -s "$KIBANA_URL" > /dev/null
then
    echo "[ERROR] Kibana is not reachable."
    exit 1
fi

echo "[OK] Kibana is reachable."

# =========================================================
# CHECK RULE DIRECTORY
# =========================================================

if [ ! -d "$RULES_DIR" ]
then
    echo "[ERROR] Rule directory not found."
    exit 1
fi

# =========================================================
# IMPORT RULES
# =========================================================

echo ""
echo "[+] Importing detection rules..."

FOUND=false

for rule in $RULES_DIR/*.json
do

    if [ -f "$rule" ]
    then

        FOUND=true

        echo ""
        echo "[+] Importing rule: $rule"

        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
            -X POST \
            "$KIBANA_URL/api/detection_engine/rules" \
            -H "Content-Type: application/json" \
            -H "kbn-xsrf: true" \
            --data @"$rule")

        if [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "201" ]
        then
            echo "[OK] Successfully imported: $rule"
        else
            echo "[WARNING] Failed to import: $rule (HTTP $RESPONSE)"
        fi

    fi

done

# =========================================================
# NO RULES FOUND
# =========================================================

if [ "$FOUND" = false ]
then
    echo "[WARNING] No rule files found."
fi

# =========================================================
# FINISHED
# =========================================================

echo ""
echo "================================================="
echo "        RULE IMPORT FINISHED"
echo "================================================="