# =========================================================
# PORT SCAN DETECTION
# SOC-IAC PLATFORM
# =========================================================

module PortScanDetection;

export {

    redef enum Notice::Type += {
        Port_Scan_Detected
    };

}

# =========================================================
# CONFIGURATION
# =========================================================

const scan_threshold = 15 &redef;
const scan_window = 1min &redef;

# =========================================================
# TRACK CONNECTIONS
# =========================================================

global scanned_ports: table[addr] of set[port]
    &default=set();

global scan_timestamps: table[addr] of time;

# =========================================================
# CONNECTION EVENT
# =========================================================

event connection_established(c: connection)
{
    local src = c$id$orig_h;
    local dst_port = c$id$resp_p;

    # Add port to scanned set
    add scanned_ports[src][dst_port];

    # Track timestamp
    scan_timestamps[src] = network_time();

    # Count scanned ports
    local port_count = |scanned_ports[src]|;

    # =====================================================
    # DETECT PORT SCAN
    # =====================================================

    if ( port_count >= scan_threshold )
    {
        NOTICE([
            $note=Port_Scan_Detected,
            $msg=fmt(
                "Possible port scan detected from %s (%d ports scanned)",
                src,
                port_count
            ),
            $src=src,
            $identifier=cat(src),
            $sub=fmt("Ports scanned: %d", port_count)
        ]);

        print fmt(
            "[PORT SCAN DETECTED] Source=%s Ports=%d",
            src,
            port_count
        );

        # Reset after detection
        delete scanned_ports[src];
    }
}

# =========================================================
# CLEANUP EXPIRED TRACKING
# =========================================================

event zeek_init()
{
    schedule scan_window {

        for ( ip in scan_timestamps )
        {
            if ( network_time() - scan_timestamps[ip] > scan_window )
            {
                delete scanned_ports[ip];
                delete scan_timestamps[ip];
            }
        }

    };
}

# =========================================================
# NOTICE EVENT LOGGING
# =========================================================

event Notice::policy(n: Notice::Info)
{
    if ( n?$note && n$note == Port_Scan_Detected )
    {
        print fmt(
            "[SOC ALERT] Port scan notice generated for %s",
            n$src
        );
    }
}