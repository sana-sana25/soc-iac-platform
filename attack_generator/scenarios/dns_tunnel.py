# =========================================================
# DNS TUNNEL ATTACK SCENARIO
# SOC-IAC PLATFORM
# =========================================================

import random
import uuid
from datetime import datetime

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "192.168.1.99",
    "10.10.10.90",
    "172.16.1.55"
]

DESTINATION_IPS = [
    "8.8.8.8",
    "1.1.1.1"
]

# =========================================================
# GENERATE DNS TUNNEL EVENT
# =========================================================

def generate_dns_tunnel():

    random_id = str(random.randint(100000, 999999))

    query = (
        "verylongbase64encodedsubdomain"
        + random_id
        + ".malicious-tunnel-domain.com"
    )

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": "dns_tunnel",

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": 53,

        "severity": "high",

        "mitre": "T1071.004",

        "message": "Simulated DNS tunneling activity detected",

        "dns_query": query,

        "query_length": len(query),

        "dns_record_type": random.choice([
            "TXT",
            "A",
            "AAAA",
            "CNAME"
        ]),

        "bytes_sent": random.randint(100, 3000),

        "bytes_received": random.randint(100, 3000),

        "protocol": "UDP",

        "country": random.choice([
            "Russia",
            "China",
            "Iran"
        ]),

        "tags": [
            "dns_tunnel_detected",
            "possible_dns_tunnel",
            "exfiltration_attempt"
        ]

    }

    return event

# =========================================================
# STANDALONE TEST
# =========================================================

if __name__ == "__main__":

    import json

    print(json.dumps(generate_dns_tunnel(), indent=4))