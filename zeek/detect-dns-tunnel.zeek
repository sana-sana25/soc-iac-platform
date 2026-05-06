# =========================================================
# DNS TUNNEL DETECTION
# SOC-IAC PLATFORM
# =========================================================

module DNSTunnelDetection;

export {

    redef enum Notice::Type += {
        DNS_Tunnel_Detected
    };

}

# =========================================================
# CONFIGURATION
# =========================================================

const dns_query_length_threshold = 50 &redef;
const dns_request_threshold = 30 &redef;
const dns_window = 1min &redef;

# =========================================================
# TRACK DNS REQUESTS
# =========================================================

global dns_requests: table[addr] of count
    &default=0;

global dns_timestamps: table[addr] of time;

# =========================================================
# DNS REQUEST EVENT
# =========================================================

event dns_request(c: connection, msg: dns_msg, query: string)
{
    local src = c$id$orig_h;

    # =====================================================
    # TRACK REQUESTS
    # =====================================================

    dns_requests[src] += 1;

    dns_timestamps[src] = network_time();

    # =====================================================
    # LONG DOMAIN DETECTION
    # =====================================================

    if ( |query| > dns_query_length_threshold )
    {
        NOTICE([
            $note=DNS_Tunnel_Detected,
            $msg=fmt(
                "Possible DNS tunneling detected from %s (long query)",
                src
            ),
            $src=src,
            $identifier=cat(src),
            $sub=query
        ]);

        print fmt(
            "[DNS TUNNEL DETECTED] Long DNS query from %s -> %s",
            src,
            query
        );
    }

    # =====================================================
    # EXCESSIVE DNS REQUESTS
    # =====================================================

    if ( dns_requests[src] >= dns_request_threshold )
    {
        NOTICE([
            $note=DNS_Tunnel_Detected,
            $msg=fmt(
                "High volume DNS activity detected from %s (%d requests)",
                src,
                dns_requests[src]
            ),
            $src=src,
            $identifier=cat(src),
            $sub=fmt(
                "DNS requests count: %d",
                dns_requests[src]
            )
        ]);

        print fmt(
            "[DNS ANOMALY DETECTED] Source=%s Requests=%d",
            src,
            dns_requests[src]
        );

        # Reset counter
        delete dns_requests[src];
    }
}

# =========================================================
# CLEANUP EXPIRED TRACKING
# =========================================================

event zeek_init()
{
    schedule dns_window {

        for ( ip in dns_timestamps )
        {
            if ( network_time() - dns_timestamps[ip] > dns_window )
            {
                delete dns_requests[ip];
                delete dns_timestamps[ip];
            }
        }

    };
}

# =========================================================
# NOTICE POLICY
# =========================================================

event Notice::policy(n: Notice::Info)
{
    if ( n?$note && n$note == DNS_Tunnel_Detected )
    {
        print fmt(
            "[SOC ALERT] DNS tunnel notice generated for %s",
            n$src
        );
    }
}