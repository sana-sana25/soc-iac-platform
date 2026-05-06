# SOC-IAC Platform

## Overview

SOC-IAC Platform is a fully automated local Security Operations Center (SOC) Infrastructure-as-Code project built using open-source cybersecurity tools.

The platform simulates a real-world SOC environment with:
- SIEM capabilities
- IDS monitoring
- SOAR integration
- Attack simulation
- Detection engineering
- Incident response
- MITRE ATT&CK mapping
- Infrastructure automation

The project is designed for:
- Cybersecurity students
- SOC analysts
- Detection engineers
- DevSecOps learning
- Blue Team practice
- Purple Team simulations

---

# Features

## SIEM Stack

- Elasticsearch
- Kibana
- Logstash

Capabilities:
- Real-time monitoring
- Log ingestion
- Alerting
- Dashboards
- Threat analytics

---

## IDS Monitoring

Using:
- Zeek Network Security Monitor

Custom detections:
- Port scanning
- SSH bruteforce
- DNS tunneling
- Reverse shell activity

---

## SOAR & Incident Response

Integrated tools:
- TheHive
- Cortex

Capabilities:
- Incident management
- Threat enrichment
- IOC analysis
- Alert triage

---

## Attack Simulation Engine

Python-based real-time attack simulation:
- Port Scan
- SSH Bruteforce
- Reverse Shell
- DNS Tunnel
- Beaconing
- Malware Download

Features:
- JSON log generation
- MITRE ATT&CK tagging
- Severity scoring
- Real-time dashboards

---

# Architecture

```text
Attack Generator
       ↓
Simulated Logs
       ↓
Logstash Pipelines
       ↓
Elasticsearch
       ↓
Kibana Dashboards
       ↓
TheHive Incidents
       ↓
Cortex Enrichment
```

---

# Project Structure

```text
soc-iac-platform/
├── docker/
├── logstash/
├── zeek/
├── detection-rules/
├── attack_generator/
├── simulated_logs/
├── scripts/
├── thehive/
├── ansible/
├── terraform/
├── dashboards/
├── docs/
└── .github/
```

---

# Technologies Used

| Category | Technologies |
|---|---|
| SIEM | Elastic Stack |
| IDS | Zeek |
| SOAR | TheHive, Cortex |
| IaC | Terraform, Ansible |
| Containers | Docker |
| CI/CD | GitHub Actions |
| Detection Rules | Sigma |
| Automation | Bash, Python |

---

# MITRE ATT&CK Coverage

| Attack | Technique |
|---|---|
| Port Scan | T1046 |
| SSH Bruteforce | T1110 |
| Reverse Shell | T1059 |
| DNS Tunnel | T1071.004 |
| Beaconing | T1071 |
| Malware Download | T1105 |

---

# Installation

## Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/soc-iac-platform.git

cd soc-iac-platform
```

---

# Start the SOC Stack

```bash
docker compose up -d
```

---

# Create Elasticsearch Indexes

```bash
./scripts/create-indexes.sh
```

---

# Import Detection Rules

```bash
./scripts/import-rules.sh
```

---

# Start Real-Time Attack Generator

```bash
./scripts/start-generator.sh
```

---

# Verify Platform Health

```bash
./scripts/healthcheck.sh
```

---

# Access Dashboards

| Service | URL |
|---|---|
| Kibana | http://localhost:5601 |
| Elasticsearch | http://localhost:9200 |
| TheHive | http://localhost:9000 |
| Cortex | http://localhost:9001 |

---

# Detection Rules

Implemented detection rules:
- Port Scan Detection
- SSH Bruteforce Detection
- DNS Tunneling Detection
- Reverse Shell Detection
- Malware Download Detection

Formats:
- Kibana Detection Rules
- Sigma Rules

---

# Automation

## Ansible Deployment

```bash
cd ansible

ansible-playbook -i inventory.ini playbook.yml
```

---

## Terraform Deployment

```bash
cd terraform

terraform init

terraform apply
```

---

# CI/CD

GitHub Actions workflows:
- CI validation pipeline
- Automated deployment pipeline

Validation includes:
- YAML validation
- JSON validation
- Python syntax checks
- Terraform validation
- Docker Compose validation

---

# Dashboards

Available dashboards:
- SOC Overview
- Threat Monitoring
- SSH Activity
- DNS Monitoring
- Reverse Shell Detection
- MITRE ATT&CK Overview

---

# Screenshots

## Kibana Dashboard

Add screenshots here.

## TheHive Cases

Add screenshots here.

## Live Attack Simulation

Add screenshots here.

---

# Future Improvements

Planned enhancements:
- Wazuh integration
- Suricata IDS
- Threat intelligence feeds
- SOAR playbooks
- Slack notifications
- Kubernetes deployment
- Cloud deployment
- Machine learning detections

---

# Educational Objectives

This project demonstrates:
- SOC architecture
- SIEM engineering
- Detection engineering
- Infrastructure as Code
- DevSecOps automation
- Incident response workflows
- Threat detection pipelines

---

# Disclaimer

This project is intended for:
- Educational purposes
- Cybersecurity learning
- Local lab environments

Do not deploy offensive simulations on unauthorized systems or networks.

---

# License

MIT License

---

# Author

Cybersecurity SOC-IAC Project

Built for:
- SOC engineering practice
- Detection engineering learning
- DevSecOps experimentation
- Blue Team simulations