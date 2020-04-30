#include <stdio.h>

#include "handler.h"
#include "release.h"
#include "terminal.h"

void zz_print_usage() {
    #define LN(x) x "\n"
    fprintf(stderr,
            LN("zizzania v" ZZ_VERSION " - Automated DeAuth attack")
            LN("Copyright (c) 2019 Andrea Cardaci <cyrus.and@gmail.com>")
            LN("")
            LN("Usage:")
            LN("")
            LN("    zizzania (-r <file> | -i <device> [-c <channel>]")
            LN("              (-n | [-d <count>] [-a <count>] [-t <seconds>]))")
            LN("             [-b <match>...] [-x <match>...] [-2 | -3]")
            LN("             [-w <file> [-g]] [-v]")
            LN("")
            LN("    -i <device>   Use <device> for both capture and injection")
            LN("    -c <channel>  Set <device> to RFMON mode on <channel>")
            LN("    -n            Passively wait for WPA handshakes")
            LN("    -d <count>    Send groups of <count> deauthentication frames")
            LN("    -a <count>    Perform <count> deauthentications before giving up")
            LN("    -t <seconds>  Time to wait between two deauthentication attempts")
            LN("    -r <file>     Read packets from <file> (- for stdin)")
            LN("    -b <match>    Limit the operations to the given BSSIDs (<address>[/<mask>])")
            LN("    -x <match>    Exclude the given stations from the operations (<address>[/<mask>])")
            LN("    -2            Settle for the first two handshake messages")
            LN("    -3            Settle for the first three handshake messages")
            LN("    -w <file>     Write packets to <file> (- for stdout)")
            LN("    -g            Also dump multicast and broadcast traffic")
            LN("    -v            Print verbose messages to stderr (toggle with SIGUSR1)")
            LN("")
            LN("Example:")
            LN("")
            LN("    zizzania -i wlan0 -c 1 -b ac:1d:1f:1e:dd:ad/ff:ff:ff:00:00:00 -w out.pcap")
            LN(""));
    #undef LN
}

void zz_print_error(const zz_handler *zz) {
    zz_err("%s", zz->error_buffer);
}

void zz_print_stats(zz_handler *zz) {
    struct pcap_stat stats;
    zz_bss *tmp, *bss;
    int n_allowed_ssid;

    if (pcap_stats(zz->pcap, &stats) == 0) {
        zz_out("");
        zz_out("Packet statistics");
        zz_out("  - Received ....... %u", stats.ps_recv);
        zz_out("  - Dropped ........ %u", stats.ps_drop + stats.ps_ifdrop);
    }

    n_allowed_ssid = 0;
    HASH_ITER(hh, zz->bsss, bss, tmp) {
        char bssid_str[ZZ_MAC_ADDR_STRING_SIZE];

        if (!bss->is_allowed) {
            continue;
        }
        n_allowed_ssid++;

        /* prepare BSSID */
        zz_mac_addr_sprint(bssid_str, bss->bssid);

        /* print stats */
        zz_out("");
        zz_out("SSID $'%s' (%s)", bss->ssid, bssid_str);
        zz_out("  - Handshakes ..... %ld", bss->n_handshakes);
        zz_out("  - Stations ....... %u", zz_members_count(&bss->stations));
        zz_out("  - Data packets ... %ld", bss->n_data_packets);
        if (bss->n_handshakes > 0 && (!zz->setup.is_live || zz->setup.output)) {
            const char *file;

            /* format file name (XXX file not shell-escaped) */
            file = (zz->setup.output ? zz->setup.output : zz->setup.input);
            file = (strcmp(file, "-") == 0 ? "CAPTURE" : file);

            /* print cracking hint */
            zz_out("  - Crack with ..... aircrack-ng -w 'WORDLIST' -b %s '%s'", bssid_str, file);

            /* print decryption hint */
            zz_out("  - Decrypt with ... airdecap-ng -e $'%s' -b %s -p 'PASSPHRASE' '%s'",
                   bss->ssid, bssid_str, file);
        }
    }

    if (n_allowed_ssid == 0) {
        zz_out("");
        zz_out("No BSS found");
        return;
    }
}
