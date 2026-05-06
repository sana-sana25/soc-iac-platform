# =========================================================
# C2 BEACONING ATTACK SCENARIO
# SOC-IAC PLATFORM
# =========================================================

import random
import uuid
from datetime import datetime

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "192.168.1.88",
    "10.10.10.60",
    "172.16.1.33"
]

DESTINATION_IPS = [
    "45.33.32.156",
    "185.220.101.1",
    "91.134.182.120"
]

USER_AGENTS = [
    "Mozilla/5.0",
    "curl/7.68.0",
    "python-requests/2.25",
    "PowerShell/7.0"
]

# =========================================================
# GENERATE BEACONING EVENT
# =========================================================

def generate_beaconing():

    interval = random.randint(10, 120)

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": "beaconing",

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": random.choice([
            80,
            443,
            8080,
            9001
        ]),

        "severity": "high",

        "mitre": "T1071",

        "message": "Simulated command and control beaconing detected",

        "beacon_interval": interval,

        "http_method": random.choice([
            "GET",
            "POST"
        ]),

        "user_agent": random.choice(USER_AGENTS),

        "bytes_sent": random.randint(100, 5000),

        "bytes_received": random.randint(100, 5000),

        "protocol": random.choice([
            "HTTP",
            "HTTPS"
        ]),

        "country": random.choice([
            "Russia",
            "China",
            "North Korea"
        ]),

        "tags": [
            "beaconing_detected",
            "c2_activity"
        ]

    }

    return event

# =========================================================
# STANDALONE TEST
# =========================================================

if __name__ == "__main__":

    import json

    print(json.dumps(generate_beaconing(), indent=4))