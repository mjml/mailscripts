#!/bin/bash

result=$(host -t A $1)
if (($? == 0)); then
    echo "$result"
fi
