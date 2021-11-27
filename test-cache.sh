#!/bin/bash

unset hc
declare -gA hc

. ./functions

echo "Getting bad ips from hostnames..."
export -f lookup_hostname
touch hostname.cache
echo "Loading hostname cache..."
load_hostname_cache
echo "Getting hostnames..."
hosts="$(get_bad_hostnames)"

echo "Number of hosts: $(wc -l <<< "$hosts")"
echo "Looking up hostnames..."
IFS=$'\n'
while read host; do
    echo "looking up $host"
    lookup_hostname "$host"
done <<< "$hosts"
echo "Saving hostname cache..."
save_hostname_cache 
echo "Hostname cache size:"
wc -l hostname.cache
