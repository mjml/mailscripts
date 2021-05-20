#!/bin/bash

source ./functions

export -f lookup_hostname

get_bad_hostnames | parallel --bar -j 30 lookup_hostname {}



