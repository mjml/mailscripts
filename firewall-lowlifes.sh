#!/bin/bash

getopts n safemode

lowlifes_ips=$(perl -ne '/Received: from \[([^\]]*?)\.(\d+)\]/m and print "$1\n"' /home/mike/.maildir/.Junk/cur/* |
    sort -n | # Sort all these IPs
    uniq -c | # Filter uniques and count
    sort -n | # Sort by count
    awk -e '{ if ($1 >= 3) { print } }') # Take the worst 20 of these

echo "IPs:"
echo "$lowlifes_ips"
#echo "$lowlifes_ips" | perl -ne '/\d+\s(\S+)/ and print "iptables -t filter -A SMTP -s $1.0/24 -j DROP\n"'  > iptables-lowlifes-cmds

lowlifes_hostnames=$(perl -ne '/Received: by (\S+) id/m and print "$1\n"' /home/mike/.maildir/.Junk/cur/*)

echo "Hostnames:"
echo "$lowlifes_hostnames"

if [[ "$safemode" == '?' ]]; then
    iptables -t filter -F SMTP
    . ./iptables-lowlifes-cmds
else
    cat ./iptables-lowlifes-cmds
fi

wc -l iptables-lowlifes-cmds
