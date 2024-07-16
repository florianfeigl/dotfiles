#!/bin/bash

# Pfad zur Helligkeitseinstellung
BRIGHTNESS_PATH="/sys/class/backlight/intel_backlight/brightness"
MAX_BRIGHTNESS_PATH="/sys/class/backlight/intel_backlight/max_brightness"

# Maximalwert der Helligkeit
MAX_BRIGHTNESS=$(cat $MAX_BRIGHTNESS_PATH)
MIN_BRIGHTNESS=1

# Funktion, um die aktuelle Helligkeit zu bekommen
get_current_brightness() {
    cat $BRIGHTNESS_PATH
}

# Funktion, um die Helligkeit anzupassen
adjust_brightness() {
    local adjustment=$1
    local current_brightness=$(get_current_brightness)
    local new_brightness=$((current_brightness + adjustment))

    if [ $new_brightness -gt $MAX_BRIGHTNESS ]; then
        new_brightness=$MAX_BRIGHTNESS
    elif [ $new_brightness -lt $MIN_BRIGHTNESS ]; then
        new_brightness=$MIN_BRIGHTNESS
    fi

    echo $new_brightness > $BRIGHTNESS_PATH
}

# Anpassung der Helligkeit basierend auf dem Argument
if [ "$1" == "up" ]; then
    adjust_brightness 100
elif [ "$1" == "down" ]; then
    adjust_brightness -100
fi

