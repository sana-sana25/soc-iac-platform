#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# KIBANA DASHBOARD IMPORTER
# =========================================================

set -e

echo "================================================="
echo "       KIBANA DASHBOARD IMPORTER"
echo "================================================="

# =========================================================
# CONFIGURATION
# =========================================================

KIBANA_URL="http://localhost:5601"

DASHBOARD_DIR="dashboards"

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
# CHECK DASHBOARD DIRECTORY
# =========================================================

if [ ! -d "$DASHBOARD_DIR" ]
then
    echo "[ERROR] Dashboard directory not found."
    exit 1
fi

# =========================================================
# IMPORT DASHBOARDS
# =========================================================

echo ""
echo "[+] Importing dashboards..."

FOUND=false

for dashboard in $DASHBOARD_DIR/*.ndjson
do

    if [ -f "$dashboard" ]
    then

        FOUND=true

        echo ""
        echo "[+] Importing: $dashboard"

        curl -X POST \
            "$KIBANA_URL/api/saved_objects/_import?overwrite=true" \
            -H "kbn-xsrf: true" \
            --form file=@"$dashboard"

        echo ""
        echo "[OK] Imported: $dashboard"

    fi

done

# =========================================================
# NO DASHBOARDS FOUND
# =========================================================

if [ "$FOUND" = false ]
then
    echo "[WARNING] No .ndjson dashboards found."
fi

# =========================================================
# FINISHED
# =========================================================

echo ""
echo "================================================="
echo "      DASHBOARD IMPORT FINISHED"
echo "================================================="