# =========================================================
# ZEEK LOCAL CONFIGURATION
# SOC-IAC PLATFORM
# =========================================================

# =========================================================
# LOAD BASE FRAMEWORKS
# =========================================================

@load base/protocols/conn
@load base/protocols/dns
@load base/protocols/http
@load base/protocols/ssl
@load base/protocols/files

# =========================================================
# LOAD NOTICE FRAMEWORK
# =========================================================

@load base/frameworks/notice

# =========================================================
# LOAD INTEL FRAMEWORK
# =========================================================

@load base/frameworks/intel

# =========================================================
# LOAD DETECTION SCRIPTS
# =========================================================

@load ./detect-port-scan.zeek
@load ./detect-bruteforce.zeek
@load ./detect-dns-tunnel.zeek
@load ./detect-reverse-shell.zeek

# =========================================================
# JSON LOGGING
# =========================================================

redef LogAscii::use_json = T;

# =========================================================
# LOG ROTATION
# =========================================================

redef Log::default_rotation_interval = 1hr;

# =========================================================
# DNS SETTINGS
# =========================================================

redef DNS::max_queries = 10000;

# =========================================================
# HTTP SETTINGS
# =========================================================

redef HTTP::default_capture_password = T;

# =========================================================
# FILE ANALYSIS
# =========================================================

redef FileExtract::prefix = "/var/log/zeek/extracted";

# =========================================================
# NOTICE SETTINGS
# =========================================================

redef Notice::mail_dest = "soc@local.lab";

# =========================================================
# CONNECTION SETTINGS
# =========================================================

redef Conn::long_connection_duration = 5min;

# =========================================================
# SSL SETTINGS
# =========================================================

redef SSL::disable_analyzer_after_detection = F;

# =========================================================
# CUSTOM NETWORKS
# =========================================================

redef Site::local_nets += {
    192.168.1.0/24
};

# =========================================================
# LOGGING EVENTS
# =========================================================

event zeek_init()
{
    print "===============================================";
    print " SOC-IAC ZEEK MONITORING INITIALIZED";
    print "===============================================";
}

# =========================================================
# CONNECTION MONITORING
# =========================================================

event connection_established(c: connection)
{
    if ( c$id$resp_p == 22/tcp )
    {
        print fmt("[SSH CONNECTION] %s -> %s",
            c$id$orig_h,
            c$id$resp_h);
    }
}

# =========================================================
# DNS MONITORING
# =========================================================

event dns_request(c: connection, msg: dns_msg, query: string)
{
    if ( |query| > 50 )
    {
        NOTICE([
            $note=Notice::ACTION_NEEDED,
            $msg=fmt("Possible DNS tunnel detected: %s", query),
            $sub=query
        ]);
    }
}

# =========================================================
# HTTP MONITORING
# =========================================================

event http_request(c: connection,
                   method: string,
                   original_URI: string,
                   unescaped_URI: string,
                   version: string)
{
    if ( /select|union|script|cmd|wget|curl/i in unescaped_URI )
    {
        NOTICE([
            $note=Notice::ACTION_NEEDED,
            $msg=fmt("Suspicious HTTP request detected: %s", unescaped_URI),
            $sub=unescaped_URI
        ]);
    }
}

# =========================================================
# FILE DOWNLOAD MONITORING
# =========================================================

event file_new(f: fa_file)
{
    if ( f?$source )
    {
        print fmt("[FILE DETECTED] %s", f$source);
    }
}

# =========================================================
# LONG CONNECTION DETECTION
# =========================================================

event connection_state_remove(c: connection)
{
    if ( c$duration > 5min )
    {
        NOTICE([
            $note=Notice::ACTION_NEEDED,
            $msg=fmt("Long duration connection detected from %s",
                c$id$orig_h),
            $sub=fmt("%s", c$duration)
        ]);
    }
}