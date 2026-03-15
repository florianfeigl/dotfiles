#!/bin/sh

while true; do
    # Battery
    cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "?")
    bat_icon=""
    [ "$cap" -gt 80 ] && bat_icon="" || [ "$cap" -gt 60 ] && bat_icon="" || [ "$cap" -gt 40 ] && bat_icon="" || [ "$cap" -gt 20 ] && bat_icon="" || bat_icon=""
    
    # Date & Time
    date=$(date '+%H:%M')
    
    # Network
    eth=$(nmcli -t -f DEVICE,TYPE,STATE dev 2>/dev/null | grep ':ethernet:connected' | cut -d: -f1)
    if [ -n "$eth" ]; then
        net_status=" eth"
    else
        ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
        if [ -n "$ssid" ]; then
            net_status=" $ssid"
        else
            net_status=" offline"
        fi
    fi
    
    # Bluetooth (if available)
    bt_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    if [ "$bt_status" = "yes" ]; then
        bt_icon=" on"
    else
        bt_icon=" off"
    fi
    
    # Audio (volume)
    volume=$(pactl list sinks 2>/dev/null | grep -A 15 "State: RUNNING" | grep "Volume:" | awk '{print $5}' | head -1 | tr -d '%')
    if [ -z "$volume" ]; then
        volume=$(pactl list sinks 2>/dev/null | grep "Volume:" | awk '{print $5}' | head -1 | tr -d '%')
    fi
    vol_icon=""
    [ -z "$volume" ] && volume="?" || [ "$volume" -eq 0 ] && vol_icon=""

    echo " $date | $net_status | $bt_icon | $vol_icon ${volume}% | $bat_icon ${cap}%"
    sleep 5
done
