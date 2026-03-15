#!/bin/bash

# Get current volume from wireplumber
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "true" || echo "false")

# Determine icon based on volume level
if [ "$muted" = "true" ]; then
    icon=""
elif [ "$volume" -ge 75 ]; then
    icon=""
elif [ "$volume" -ge 50 ]; then
    icon=""
elif [ "$volume" -ge 25 ]; then
    icon=""
else
    icon=""
fi

echo "{\"output\": \"$icon $volume%\"}"
