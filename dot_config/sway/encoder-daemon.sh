#!/bin/bash

# Keychron V1 Encoder Daemon
# Handles Press+Rotate: Rotate=Volume, Press=Mute
# Dependencies: libinput (libinput debug-events), wpctl

set -e

VOLUME_STEP=5      # %

# Find Keychron device
find_keychron() {
    # Look for Keychron in device tree
    local device
    device=$(libinput list-devices 2>/dev/null | grep -A5 "Keychron" | grep "Kernel:" | head -1 | awk '{print $NF}')
    
    if [ -n "$device" ]; then
        echo "$device"
        return 0
    fi
    
    # Fallback: look for any keyboard
    device=$(libinput list-devices 2>/dev/null | grep "Keyboard" | grep "Kernel:" | head -1 | awk '{print $NF}')
    if [ -n "$device" ]; then
        echo "$device"
        return 0
    fi
    
    return 1
}

# Parse libinput debug output
main() {
    local ENCODER_DEVICE
    ENCODER_DEVICE=$(find_keychron)
    
    if [ -z "$ENCODER_DEVICE" ]; then
        echo "ERROR: Keychron/Keyboard device not found" >&2
        exit 1
    fi
    
    echo "Monitoring encoder on: $ENCODER_DEVICE" >&2
    
    # Monitor with libinput debug-events
    # Looking for:
    # - POINTER_MOTION_UNACCELERATED with axis REL_WHEEL (rotation)
    # - KEY_PRESS for button events
    
    libinput debug-events "$ENCODER_DEVICE" 2>&1 | while read -r line; do
        # Handle rotation (REL_WHEEL axis events)
        if echo "$line" | grep -q "POINTER_MOTION_UNACCELERATED.*REL_WHEEL"; then
            if echo "$line" | grep -q " 1)$"; then
                # Wheel up
                wpctl set-volume @DEFAULT_AUDIO_SINK@ +${VOLUME_STEP}% || true
            elif echo "$line" | grep -q " -1)$"; then
                # Wheel down
                wpctl set-volume @DEFAULT_AUDIO_SINK@ -${VOLUME_STEP}% || true
            fi
        fi
        
        # Handle press (BTN_LEFT or similar button press)
        if echo "$line" | grep -q "BUTTON_PRESS.*BTN_"; then
            # Short press = toggle mute
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle || true
        fi
    done
}

# Trap signals for clean shutdown
trap 'exit 0' SIGTERM SIGINT

main "$@"
