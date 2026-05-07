#!/usr/bin/env python3

# =========================================================
# SOC-IAC PLATFORM
# REAL-TIME ATTACK GENERATOR
# =========================================================

import json
import random
import time
import uuid
from datetime import datetime

# =========================================================
# CONFIGURATION
# =========================================================

LOG_FILE = "simulated_logs/attacks.json"

EVENT_INTERVAL = 15

# =========================================================
# SAMPLE DATA
# =========================================================

SOURCE_IPS = [
    "192.168.1.50",
    "10.0.0.23",
    "172.16.1.15",
    "185.220.101.1",
    "45.33.32.156",
    "8.8.8.8"
]

DESTINATION_IPS = [
    "192.168.1.10",
    "192.168.1.20",
    "10.10.10.5"
]

USERS = [
    "root",
    "admin",
    "ubuntu",
    "test",
    "guest"
]

ATTACK_TYPES = [
    "port_scan",
    "ssh_bruteforce",
    "reverse_shell",
    "dns_tunnel",
    "malware_download",
    "beaconing"
]

MITRE_MAPPING = {
    "port_scan": "T1046",
    "ssh_bruteforce": "T1110",
    "reverse_shell": "T1059",
    "dns_tunnel": "T1071.004",
    "malware_download": "T1105",
    "beaconing": "T1071"
}

SEVERITY_MAPPING = {
    "port_scan": "medium",
    "ssh_bruteforce": "high",
    "reverse_shell": "critical",
    "dns_tunnel": "high",
    "malware_download": "critical",
    "beaconing": "high"
}

PORT_MAPPING = {
    "port_scan": random.randint(1, 65535),
    "ssh_bruteforce": 22,
    "reverse_shell": 4444,
    "dns_tunnel": 53,
    "malware_download": 80,
    "beaconing": 8080
}

# =========================================================
# GENERATE EVENT
# =========================================================

def generate_event():

    attack_type = random.choice(ATTACK_TYPES)

    event = {

        "event_id": str(uuid.uuid4()),

        "timestamp": datetime.utcnow().isoformat(),

        "event_type": attack_type,

        "src_ip": random.choice(SOURCE_IPS),

        "dest_ip": random.choice(DESTINATION_IPS),

        "src_port": random.randint(1024, 65535),

        "dest_port": PORT_MAPPING[attack_type],

        "username": random.choice(USERS),

        "severity": SEVERITY_MAPPING[attack_type],

        "mitre": MITRE_MAPPING[attack_type],

        "message": f"Simulated {attack_type} attack detected",

        "bytes_sent": random.randint(100, 50000),

        "bytes_received": random.randint(100, 50000),

        "protocol": random.choice(["TCP", "UDP"]),

        "country": random.choice([
            "Russia",
            "China",
            "United States",
            "Germany",
            "France",
            "Brazil"
        ]),

        "process_name": random.choice([
            "powershell.exe",
            "bash",
            "nc",
            "python",
            "wget"
        ])
    }

    # =====================================================
    # ATTACK-SPECIFIC DATA
    # =====================================================

    if attack_type == "port_scan":

        event["scanned_ports"] = random.randint(10, 200)

    elif attack_type == "ssh_bruteforce":

        event["failed_attempts"] = random.randint(5, 50)

    elif attack_type == "reverse_shell":

        event["shell_type"] = random.choice([
            "bash",
            "powershell",
            "netcat"
        ])

    elif attack_type == "dns_tunnel":

        event["dns_query"] = (
            "verylongsuspiciousdomain"
            + str(random.randint(1000, 9999))
            + ".malicious.com"
        )

    elif attack_type == "malware_download":

        event["file_name"] = random.choice([
            "payload.exe",
            "backdoor.dll",
            "malware.ps1",
            "ransomware.sh"
        ])

    elif attack_type == "beaconing":

        event["beacon_interval"] = random.randint(10, 120)

    return event

# =========================================================
# WRITE EVENT
# =========================================================

def write_event(event):

    with open(LOG_FILE, "a") as f:

        json.dump(event, f)

        f.write("\n")

# =========================================================
# MAIN LOOP
# =========================================================

def main():

    print("=================================================")
    print(" SOC-IAC REAL-TIME ATTACK GENERATOR STARTED")
    print("=================================================")

    print(f"[+] Writing logs to: {LOG_FILE}")

    while True:

        event = generate_event()

        write_event(event)

        print(
            f"[{event['severity'].upper()}] "
            f"{event['event_type']} "
            f"{event['src_ip']} -> {event['dest_ip']}"
        )

        time.sleep(EVENT_INTERVAL)

# =========================================================
# ENTRYPOINT
# =========================================================

if __name__ == "__main__":

    main()
