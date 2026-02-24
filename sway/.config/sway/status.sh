#!/bin/sh

while true; do
    cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "?")
    date=$(date '+%Y-%m-%d %H:%M:%S')
    eth=$(nmcli -t -f DEVICE,TYPE,STATE dev 2>/dev/null | grep ':ethernet:connected' | cut -d: -f1)
    [ -z "$eth" ] && eth="no wired"
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
    [ -z "$ssid" ] && ssid="no wifi"

    echo "${cap}% | ${eth} | ${ssid} | ${date}"
    sleep 5
done
