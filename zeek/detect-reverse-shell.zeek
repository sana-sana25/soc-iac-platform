# =========================================================
# REVERSE SHELL DETECTION
# SOC-IAC PLATFORM
# =========================================================

module ReverseShellDetection;

export {

    redef enum Notice::Type += {
        Reverse_Shell_Detected
    };

}

# =========================================================
# CONFIGURATION
# =========================================================

const suspicious_ports = {
    4444/tcp,
    5555/tcp,
    6666/tcp,
    1337/tcp,
    9001/tcp,
    8081/tcp
};

const long_connection_threshold = 5min &redef;

# =========================================================
# CONNECTION EVENT
# =========================================================

event connection_established(c: connection)
{
    local src = c$id$orig_h;
    local dst = c$id$resp_h;
    local dst_port = c$id$resp_p;

    # =====================================================
    # SUSPICIOUS PORT DETECTION
    # =====================================================

    if ( dst_port in suspicious_ports )
    {
        NOTICE([
            $note=Reverse_Shell_Detected,
            $msg=fmt(
                "Possible reverse shell connection detected: %s -> %s:%s",
                src,
                dst,
                dst_port
            ),
            $src=src,
            $identifier=cat(src),
            $sub=fmt(
                "Suspicious destination port: %s",
                dst_port
            )
        ]);

        print fmt(
            "[REVERSE SHELL DETECTED] %s -> %s:%s",
            src,
            dst,
            dst_port
        );
    }
}

# =========================================================
# LONG CONNECTION DETECTION
# =========================================================

event connection_state_remove(c: connection)
{
    local src = c$id$orig_h;
    local dst = c$id$resp_h;

    if ( c$duration > long_connection_threshold )
    {
        NOTICE([
            $note=Reverse_Shell_Detected,
            $msg=fmt(
                "Long suspicious connection detected from %s to %s",
                src,
                dst
            ),
            $src=src,
            $identifier=cat(src),
            $sub=fmt(
                "Connection duration: %s",
                c$duration
            )
        ]);

        print fmt(
            "[LONG CONNECTION ALERT] %s -> %s Duration=%s",
            src,
            dst,
            c$duration
        );
    }
}

# =========================================================
# COMMAND EXECUTION INDICATORS
# =========================================================

event http_request(c: connection,
                   method: string,
                   original_URI: string,
                   unescaped_URI: string,
                   version: string)
{
    if ( /cmd|shell|exec|powershell|bash|nc|netcat/i in unescaped_URI )
    {
        NOTICE([
            $note=Reverse_Shell_Detected,
            $msg=fmt(
                "Possible command execution activity detected: %s",
                unescaped_URI
            ),
            $src=c$id$orig_h,
            $identifier=cat(c$id$orig_h),
            $sub=unescaped_URI
        ]);

        print fmt(
            "[COMMAND EXECUTION DETECTED] %s",
            unescaped_URI
        );
    }
}

# =========================================================
# NOTICE POLICY
# =========================================================

event Notice::policy(n: Notice::Info)
{
    if ( n?$note && n$note == Reverse_Shell_Detected )
    {
        print fmt(
            "[SOC ALERT] Reverse shell notice generated for %s",
            n$src
        );
    }
}

# =========================================================
# INIT EVENT
# =========================================================

event zeek_init()
{
    print "===============================================";
    print " REVERSE SHELL DETECTION MODULE LOADED";
    print "===============================================";
}