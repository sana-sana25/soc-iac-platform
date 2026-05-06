#!/bin/bash

# =========================================================
# SOC-IAC-PLATFORM BOOTSTRAP
# Automated Local SOC Deployment
# =========================================================

set -e

echo "================================================="
echo "      SOC-IAC PLATFORM BOOTSTRAP STARTING"
echo "================================================="

sleep 2

# =========================================================
# CHECK ROOT
# =========================================================

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run as root or with sudo."
    exit 1
fi

# =========================================================
# SYSTEM UPDATE
# =========================================================

echo "[+] Updating system packages..."

apt update -y
apt upgrade -y

# =========================================================
# INSTALL REQUIRED PACKAGES
# =========================================================

echo "[+] Installing dependencies..."

apt install -y \
    curl \
    wget \
    git \
    unzip \
    python3 \
    python3-pip \
    docker.io \
    docker-compose \
    net-tools \
    jq

# =========================================================
# ENABLE DOCKER
# =========================================================

echo "[+] Enabling Docker service..."

systemctl enable docker
systemctl start docker

# =========================================================
# CREATE PROJECT DIRECTORIES
# =========================================================

echo "[+] Creating required directories..."

mkdir -p simulated_logs
mkdir -p logstash/pipeline
mkdir -p logstash/patterns

mkdir -p docker/elasticsearch
mkdir -p docker/kibana
mkdir -p docker/thehive
mkdir -p docker/cortex

mkdir -p attack_generator
mkdir -p dashboards
mkdir -p detection-rules
mkdir -p scripts

# =========================================================
# PERMISSIONS
# =========================================================

echo "[+] Setting permissions..."

chmod -R 755 .

# =========================================================
# CHECK DOCKER INSTALLATION
# =========================================================

echo "[+] Verifying Docker installation..."

docker --version
docker compose version || true

# =========================================================
# START SOC STACK
# =========================================================

echo "[+] Starting SOC containers..."

docker compose down || true
docker compose up -d

# =========================================================
# WAIT FOR SERVICES
# =========================================================

echo "[+] Waiting for services to initialize..."

sleep 20

# =========================================================
# DISPLAY CONTAINER STATUS
# =========================================================

echo "================================================="
echo "                 CONTAINER STATUS"
echo "================================================="

docker ps

# =========================================================
# DISPLAY ACCESS URLS
# =========================================================

IP_ADDR=$(hostname -I | awk '{print $1}')

echo ""
echo "================================================="
echo "                SOC ACCESS URLS"
echo "================================================="
echo ""
echo "[KIBANA]        http://$IP_ADDR:5601"
echo "[ELASTICSEARCH] http://$IP_ADDR:9200"
echo "[THEHIVE]       http://$IP_ADDR:9000"
echo "[CORTEX]        http://$IP_ADDR:9001"
echo ""

# =========================================================
# HEALTH CHECK
# =========================================================

echo "[+] Running basic health checks..."

sleep 10

curl -s http://localhost:9200 >/dev/null \
    && echo "[OK] Elasticsearch is reachable." \
    || echo "[ERROR] Elasticsearch is not reachable."

curl -s http://localhost:5601 >/dev/null \
    && echo "[OK] Kibana is reachable." \
    || echo "[ERROR] Kibana is not reachable."

# =========================================================
# FINAL MESSAGE
# =========================================================

echo ""
echo "================================================="
echo "        SOC-IAC PLATFORM DEPLOYED"
echo "================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Configure Elasticsearch"
echo "2. Configure Kibana"
echo "3. Configure Logstash pipelines"
echo "4. Launch attack generator"
echo "5. Create dashboards and alerts"
echo ""
echo "================================================="