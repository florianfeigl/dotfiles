#!/usr/bin/env bash

# Get the current volume of the default sink
VOLUME=$(pactl get-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo | grep -oP '\d+%' | head -1 | tr -d '%')

# Limit the volume to 100%
if [ "$VOLUME" -gt 100 ]; then
    VOLUME=100
fi

echo "Volume: ${VOLUME}%"

