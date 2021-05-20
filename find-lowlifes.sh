#!/bin/bash

getopts n safemode

lowlifes_ips=$(perl -ne '/Received: from \[([^\]]*?)\]/m and print "$1\n"' /home/mike/.maildir/.Junk/cur/* \
    | sort -n  \
    | uniq -c  \
    | sort -n  \
    | awk -e '{ print $2 "/32 " $1 }' \
    | sort -n )

echo "IPs:"
echo "$lowlifes_ips"

#lowlifes_hostnames=$(perl -ne '/Received: by (\S+) id/m and print "$1\n"' /home/mike/.maildir/.Junk/cur/*)

#echo "Hostnames:"
#echo "$lowlifes_hostnames"

