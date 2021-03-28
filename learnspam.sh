#!/bin/bash

learn=/usr/bin/vendor_perl/sa-learn
prevdate=$(cat learn.ts)
date +"%Y-%m-%d %H:%M" > learn.ts

cd /home/mike/.maildir/cur
echo "Learning Ham since $prevdate..."
hamfiles=$(ls -lA --time-style=long-iso | awk -v date="$prevdate" -e '{ d = $6 " " $7;  if (date < d) { print $8 } }')
if [[ -n "$hamfiles" ]]; then
    $learn --ham $hamfiles
else
    echo "None!"
fi

cd /home/mike/.maildir/.Junk/cur
echo "Learning Spam since $prevdate..."
spamfiles=$(ls -lA --time-style=long-iso | awk -v date="$prevdate" -e '{ d = $6 " " $7;  if (date < d) { print $8 } }')
if [[ -n "$spamfiles" ]]; then
    $learn --spam $spamfiles
else
    echo "None!"
fi

