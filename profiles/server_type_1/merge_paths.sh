#!/usr/bin/env bash

set -e

echo "$@" | xargs cat >> together.env
sort -o together.env together.env

while read -r line
do
    [[ -n $(echo "${line}" | cut -f1 -d= | grep -wv "PATH" | grep -wv "PYTHONPATH") ]] && export ${line}
    [[ -n $(echo "${line}" | cut -f1 -d= | grep -w "PATH") ]] && export PATH=$( echo "${line}" | cut -f2 -d= ):$PATH
done < together.env

# Remove duplicates
export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '!x[$0]++' | sed "s/\(.*\).\{1\}/\1/")
