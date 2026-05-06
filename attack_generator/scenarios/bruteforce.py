# =========================================================
# SSH BRUTEFORCE ATTACK SCENARIO
# SOC-IAC PLATFORM
# =========================================================

import random
import uuid
from datetime import datetime

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "45.155.205.233",
    "91.134.182.120",
    "192.168.1.66",
    "10.10.10.25"
]

DESTINATION_IPS = [
    "192.168.1.10",
    "192.168.1.20"
]

USERNAMES = [
    "root",
    "admin",
    "ubuntu",
    "test",
    "guest"
]

# =========================================================
# GENERATE BRUTEFORCE EVENT
# =========================================================

def generate_bruteforce():

    failed_attempts = random.randint(5, 100)

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": "ssh_bruteforce",

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": 22,

        "severity": "high",

        "mitre": "T1110",

        "message": "Simulated SSH bruteforce attack detected",

        "username": random.choice(USERNAMES),

        "failed_attempts": failed_attempts,

        "authentication_method": random.choice([
            "password",
            "keyboard-interactive"
        ]),

        "protocol": "TCP",

        "country": random.choice([
            "Russia",
            "China",
            "North Korea",
            "Iran"
        ]),

        "process_name": random.choice([
            "hydra",
            "medusa",
            "ncrack"
        ]),

        "tags": [
            "ssh_bruteforce_detected",
            "credential_attack",
            "possible_bruteforce"
        ]

    }

    return event

# =========================================================
# STANDALONE TEST
# =========================================================

if __name__ == "__main__":

    import json

    print(json.dumps(generate_bruteforce(), indent=4))