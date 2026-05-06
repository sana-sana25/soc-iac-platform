# =========================================================
# PORT SCAN ATTACK SCENARIO
# SOC-IAC PLATFORM
# =========================================================

import random
import uuid
from datetime import datetime

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "185.220.101.1",
    "45.33.32.156",
    "192.168.1.50",
    "10.0.0.99"
]

DESTINATION_IPS = [
    "192.168.1.10",
    "192.168.1.20"
]

# =========================================================
# GENERATE PORT SCAN EVENT
# =========================================================

def generate_port_scan():

    scanned_ports = random.randint(10, 300)

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": "port_scan",

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": random.randint(1, 65535),

        "severity": "medium",

        "mitre": "T1046",

        "message": "Simulated port scan activity detected",

        "scanned_ports": scanned_ports,

        "scan_type": random.choice([
            "SYN_SCAN",
            "TCP_CONNECT",
            "UDP_SCAN",
            "XMAS_SCAN"
        ]),

        "protocol": random.choice([
            "TCP",
            "UDP"
        ]),

        "country": random.choice([
            "Russia",
            "China",
            "Brazil",
            "Germany"
        ]),

        "tags": [
            "port_scan_detected",
            "network_attack"
        ]

    }

    return event

# =========================================================
# STANDALONE TEST
# =========================================================

if __name__ == "__main__":

    import json

    print(json.dumps(generate_port_scan(), indent=4))