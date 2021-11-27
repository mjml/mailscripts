#!/bin/bash

. ./functions

echo "Getting bad ips from hostnames..."
export -f lookup_hostname
declare -A hc
touch hostname.cache
load_hostname_cache hc

hosts="$(get_bad_hostnames)"

echo "Number of hosts: $(wc -l <<< "$hosts")"
echo "Looking up hostnames..."
ips1=''
IFS=$'\n'
while read host; do
    ips1+=$(lookup_hostname "$host")
done <<< "$hosts"

save_hostname_cache hc
echo "Hostname cache size:"
wc -l hostname.cache
echo "Getting bad ips from emails..."
ips2=$(get_bad_ips)
echo "Adding in hand-tailored lists..."
ips3=$(cat data/manual-bad-cidr.txt)
ips4=$(cat data/quadranet.txt)
ips=$(echo -e "$ips1\n$ips2\n$ips3" | sort -n)

echo "$ips" | cidrcompressor/cidrcompressor | sort -k 2 -n | awk -e '{ print "iptables -t filter -A SMTP -s " $1 " -j DROP"  }' > iptables-cmds.sh

iptables -t filter -f SMTP

source ./iptables-cmds.sh



