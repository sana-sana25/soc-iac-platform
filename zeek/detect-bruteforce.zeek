# =========================================================
# SSH BRUTEFORCE DETECTION
# SOC-IAC PLATFORM
# =========================================================

module BruteforceDetection;

export {

    redef enum Notice::Type += {
        SSH_Bruteforce_Detected
    };

}

# =========================================================
# CONFIGURATION
# =========================================================

const bruteforce_threshold = 10 &redef;
const bruteforce_window = 2min &redef;

# =========================================================
# TRACK FAILED SSH CONNECTIONS
# =========================================================

global failed_ssh_attempts: table[addr] of count
    &default=0;

global failed_ssh_timestamps: table[addr] of time;

# =========================================================
# CONNECTION EVENT
# =========================================================

event connection_established(c: connection)
{
    local src = c$id$orig_h;
    local dst_port = c$id$resp_p;

    # =====================================================
    # SSH PORT CHECK
    # =====================================================

    if ( dst_port == 22/tcp )
    {
        failed_ssh_attempts[src] += 1;

        failed_ssh_timestamps[src] = network_time();

        # =================================================
        # DETECT BRUTEFORCE
        # =================================================

        if ( failed_ssh_attempts[src] >= bruteforce_threshold )
        {
            NOTICE([
                $note=SSH_Bruteforce_Detected,
                $msg=fmt(
                    "Possible SSH bruteforce detected from %s (%d attempts)",
                    src,
                    failed_ssh_attempts[src]
                ),
                $src=src,
                $identifier=cat(src),
                $sub=fmt(
                    "SSH failed attempts: %d",
                    failed_ssh_attempts[src]
                )
            ]);

            print fmt(
                "[SSH BRUTEFORCE DETECTED] Source=%s Attempts=%d",
                src,
                failed_ssh_attempts[src]
            );

            # Reset counter after detection
            delete failed_ssh_attempts[src];
        }
    }
}

# =========================================================
# CLEANUP EXPIRED ENTRIES
# =========================================================

event zeek_init()
{
    schedule bruteforce_window {

        for ( ip in failed_ssh_timestamps )
        {
            if ( network_time() - failed_ssh_timestamps[ip] > bruteforce_window )
            {
                delete failed_ssh_attempts[ip];
                delete failed_ssh_timestamps[ip];
            }
        }

    };
}

# =========================================================
# NOTICE POLICY
# =========================================================

event Notice::policy(n: Notice::Info)
{
    if ( n?$note && n$note == SSH_Bruteforce_Detected )
    {
        print fmt(
            "[SOC ALERT] SSH bruteforce notice generated for %s",
            n$src
        );
    }
}