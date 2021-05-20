#!/bin/bash

# Options:
#  -n:            Don't evaluate the rules, just print them
#  -b,--block:    Don't process the /32 addresses, only the CIDR blocks

cmdline=$(getopt -o nb --long block -- "$@")
eval set -- "$cmdline"
while true; do
    case "$1" in
	-q)
	    quiet=1; shift 1 ;;
	-b|--block)
	    block="-b"; shift 1 ;;
	--) shift ; break ;;
	*) echo "$1"; exit 1 ;;
    esac 
done

source ./functions

iptables -t filter -F SMTP

rulecmds=$(create_firewall_rules $block)

if [[ -z $quiet ]]; then
    eval "$rulecmds"
else
    echo "$rulecmds"
fi

