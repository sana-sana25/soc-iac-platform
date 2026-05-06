# SOC-IAC PLATFORM ARCHITECTURE

## Overview

SOC-IAC Platform is a local Security Operations Center (SOC) Infrastructure-as-Code project designed to simulate a modern SOC environment using open-source technologies.

The platform integrates:

- SIEM capabilities
- IDS monitoring
- SOAR orchestration
- Attack simulation
- Detection engineering
- MITRE ATT&CK mapping
- Incident response workflows

The project is fully containerized and automation-ready using:
- Docker Compose
- Ansible
- Terraform

---

# Global Architecture

```text
                    +----------------------+
                    |  Attack Generator    |
                    |  (Python Simulation) |
                    +----------+-----------+
                               |
                               v
                    +----------------------+
                    |  Simulated Logs      |
                    |  JSON Event Files    |
                    +----------+-----------+
                               |
                               v
+-------------+     +----------------------+     +----------------------+
|    Zeek     | --> |      Logstash        | --> |    Elasticsearch     |
|   Network   |     |  Parsing & Enrich    |     |      SIEM Core       |
| Monitoring  |     +----------------------+     +----------+-----------+
+------+------+                                           |
       |                                                    |
       v                                                    v
+-------------+                                  +----------------------+
| Zeek Logs   |                                  |       Kibana         |
| conn.log    |                                  | Dashboards & Alerts  |
| dns.log     |                                  +----------+-----------+
| notice.log  |                                             |
+-------------+                                             |
                                                            v
                                               +----------------------+
                                               |       TheHive        |
                                               | Incident Response    |
                                               +----------+-----------+
                                                          |
                                                          v
                                               +----------------------+
                                               |        Cortex        |
                                               | Threat Analyzers     |
                                               +----------------------+