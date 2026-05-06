#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# ELASTICSEARCH INDEX CREATOR
# =========================================================

set -e

echo "================================================="
echo "        ELASTICSEARCH INDEX CREATOR"
echo "================================================="

# =========================================================
# CONFIGURATION
# =========================================================

ELASTIC_URL="http://localhost:9200"

# =========================================================
# INDEX LIST
# =========================================================

INDEXES=(
    "soc-simulated"
    "soc-alerts"
    "linux-auth"
    "zeek"
)

# =========================================================
# CHECK ELASTICSEARCH
# =========================================================

echo "[+] Checking Elasticsearch availability..."

if ! curl -s "$ELASTIC_URL" > /dev/null
then
    echo "[ERROR] Elasticsearch is not reachable."
    exit 1
fi

echo "[OK] Elasticsearch is reachable."

# =========================================================
# CREATE INDEXES
# =========================================================

echo ""
echo "[+] Creating indexes..."

for index in "${INDEXES[@]}"
do

    echo ""
    echo "[+] Creating index: $index"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X PUT \
        "$ELASTIC_URL/$index" \
        -H "Content-Type: application/json" \
        -d '
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {

      "@timestamp": {
        "type": "date"
      },

      "event_type": {
        "type": "keyword"
      },

      "severity": {
        "type": "keyword"
      },

      "src_ip": {
        "type": "ip"
      },

      "dest_ip": {
        "type": "ip"
      },

      "mitre": {
        "type": "keyword"
      },

      "message": {
        "type": "text"
      },

      "tags": {
        "type": "keyword"
      }

    }
  }
}')

    if [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "201" ]
    then
        echo "[OK] Index created: $index"
    else
        echo "[WARNING] Failed or already exists: $index (HTTP $RESPONSE)"
    fi

done

# =========================================================
# SHOW INDEXES
# =========================================================

echo ""
echo "================================================="
echo "              CURRENT INDEXES"
echo "================================================="

curl -s "$ELASTIC_URL/_cat/indices?v"

# =========================================================
# FINISHED
# =========================================================

echo ""
echo "================================================="
echo "         INDEX CREATION FINISHED"
echo "================================================="
