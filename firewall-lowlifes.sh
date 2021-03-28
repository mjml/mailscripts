#!/bin/bash

getopts n safemode

perl -0777 -ne '/Received: from \[([^\]]*)\] \(port=(\d*) (helo=[^\)]*?)\)\s*\n\s+by (\S+)/sm and print "$1 $2 $3 $4\n"' * >> ../../firewall-lowlifes.sh 

lowlifes=$(perl -ne '/Received: from \[([^\]]*?)\.(\d+)\]/m and print "$1\n"' /home/mike/.maildir/.Junk/cur/* |
    sort -n | # Sort all these IPs
    uniq -c | # Filter uniques and count
    sort -n | # Sort by count
    awk -e '{ if ($1 >= 3) { print } }') # Take the worst 20 of these
   
echo "$lowlifes" | perl -ne '/\d+\s(\S+)/ and print "iptables -t filter -A SMTP -s $1.0/24 -j DROP\n"'  > iptables-lowlifes-cmds

if [[ "$safemode" == '?' ]]; then
    iptables -t filter -F SMTP
    . ./iptables-lowlifes-cmds
else
    echo "$lowlifes"
    cat ./iptables-lowlifes-cmds
fi

wc -l iptables-lowlifes-cmds
