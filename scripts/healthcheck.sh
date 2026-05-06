#!/bin/bash

# =========================================================
# SOC-IAC PLATFORM
# HEALTHCHECK SCRIPT
# =========================================================

echo "================================================="
echo "           SOC-IAC HEALTHCHECK"
echo "================================================="

# =========================================================
# CONFIGURATION
# =========================================================

ELASTIC_URL="http://localhost:9200"

KIBANA_URL="http://localhost:5601"

THEHIVE_URL="http://localhost:9000"

CORTEX_URL="http://localhost:9001"

# =========================================================
# COLORS
# =========================================================

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

# =========================================================
# FUNCTION
# =========================================================

check_service() {

    local name=$1
    local url=$2

    echo -n "[+] Checking $name ... "

    if curl -s "$url" > /dev/null
    then
        echo -e "${GREEN}ONLINE${NC}"
    else
        echo -e "${RED}OFFLINE${NC}"
    fi
}

# =========================================================
# DOCKER CHECK
# =========================================================

echo ""
echo "================================================="
echo " DOCKER CONTAINERS"
echo "================================================="

docker ps --format "table {{.Names}}\t{{.Status}}"

# =========================================================
# SERVICES CHECK
# =========================================================

echo ""
echo "================================================="
echo " SERVICES STATUS"
echo "================================================="

check_service "Elasticsearch" "$ELASTIC_URL"

check_service "Kibana" "$KIBANA_URL"

check_service "TheHive" "$THEHIVE_URL"

check_service "Cortex" "$CORTEX_URL"

# =========================================================
# ELASTICSEARCH INDEXES
# =========================================================

echo ""
echo "================================================="
echo " ELASTICSEARCH INDEXES"
echo "================================================="

curl -s "$ELASTIC_URL/_cat/indices?v"

# =========================================================
# LOG FILES
# =========================================================

echo ""
echo "================================================="
echo " SIMULATED LOG FILES"
echo "================================================="

FILES=(
    "simulated_logs/attacks.json"
    "simulated_logs/auth_events.json"
    "simulated_logs/network_events.json"
    "simulated_logs/dns_events.json"
)

for file in "${FILES[@]}"
do

    if [ -f "$file" ]
    then
        echo -e "[OK] $file"
    else
        echo -e "${YELLOW}[MISSING]${NC} $file"
    fi

done

# =========================================================
# GENERATOR PROCESS
# =========================================================

echo ""
echo "================================================="
echo " ATTACK GENERATOR"
echo "================================================="

if pgrep -f "generator.py" > /dev/null
then
    echo -e "${GREEN}[RUNNING]${NC} attack_generator/generator.py"
else
    echo -e "${RED}[STOPPED]${NC} generator.py"
fi

# =========================================================
# FINAL STATUS
# =========================================================

echo ""
echo "================================================="
echo " HEALTHCHECK COMPLETED"
echo "================================================="