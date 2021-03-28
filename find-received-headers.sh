#!/bin/bash

#perl -ne '/^Received: from \[([^\]]*)\.\d+\] \(port=(\d*) (helo=[^\)]*?)\)/sm and print' /home/mike/.maildir/.Junk/cur/*

grep -P -A 3 --color=always 'Received:' $@
