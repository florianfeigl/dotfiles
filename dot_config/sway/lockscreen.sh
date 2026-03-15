#!/bin/bash
#
# Sway Lockscreen with Information Display
# For Sway (Debian systems)
# Features: Time, Date, Battery, Network Status
# Dependencies: swaylock, grim, imagemagick (convert), playerctl (optional)
#

set -e

# Colors (Catppuccin Macchiato)
BG="#24273a"

# Paths
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lockscreen"
BLUR_IMG="$CACHE_DIR/blur.png"
SNAPSHOT_IMG="$CACHE_DIR/snapshot.png"

mkdir -p "$CACHE_DIR"

# Function: Get system info
get_time() { date '+%H:%M:%S'; }
get_date() { date '+%A, %d.%B %Y'; }
get_battery() {
    local cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "?")
    echo "$cap%"
}
get_network() {
    local eth=$(nmcli -t -f ACTIVE,DEVICE dev 2>/dev/null | grep '^yes.*eth' | head -1)
    if [ -n "$eth" ]; then
        echo "Ethernet"
    else
        local ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
        [ -n "$ssid" ] && echo "$ssid" || echo "Offline"
    fi
}

# Create blur effect from current screen
create_blur() {
    echo "[*] Creating blur effect..."
    
    # Take screenshot
    if command -v grim &>/dev/null; then
        grim "$SNAPSHOT_IMG"
    else
        echo "[!] grim not found, using solid color"
        convert -size 1920x1080 "xc:$BG" "$SNAPSHOT_IMG"
        return
    fi
    
    # Apply blur using ImageMagick
    if command -v convert &>/dev/null; then
        convert "$SNAPSHOT_IMG" \
            -blur 0x8 \
            "$BLUR_IMG"
    else
        cp "$SNAPSHOT_IMG" "$BLUR_IMG"
    fi
}

# Create info display (using text overlay)
create_info_image() {
    local time=$(get_time)
    local date=$(get_date)
    local battery=$(get_battery)
    local network=$(get_network)
    
    # Create text overlay image
    convert -size 1920x1080 xc:transparent \
        -font "DejaVu-Sans-Bold" -pointsize 120 -fill "#c6a0f6" \
        -gravity Center -annotate +0+100 "$time" \
        -font "DejaVu-Sans" -pointsize 20 -fill "#cad3f5" \
        -gravity Center -annotate +0-100 "$date" \
        -font "DejaVu-Sans" -pointsize 16 -fill "#6e738d" \
        -gravity SouthEast -annotate +30+30 "🔋 $battery" \
        -gravity SouthWest -annotate +30+30 "📡 $network" \
        "$CACHE_DIR/info.png"
}

# Composite info onto blur
composite_lockscreen() {
    if [ -f "$CACHE_DIR/info.png" ]; then
        convert "$BLUR_IMG" "$CACHE_DIR/info.png" -composite "$BLUR_IMG"
    fi
}

# Lock the screen
lock_screen() {
    echo "[*] Locking screen with swaylock..."
    
    if command -v swaylock &>/dev/null; then
        swaylock -f -i "$BLUR_IMG" -c "$BG"
    else
        echo "[!] swaylock not found!"
        exit 1
    fi
}

# Main
main() {
    echo "[*] Starting Sway lockscreen..."
    
    # Pause music if playing
    if command -v playerctl &>/dev/null; then
        playerctl pause 2>/dev/null || true
    fi
    
    # Create blur background
    create_blur
    
    # Create info overlay
    create_info_image
    
    # Composite info onto blur
    composite_lockscreen
    
    # Lock the screen
    lock_screen
    
    # Cleanup
    rm -f "$SNAPSHOT_IMG" "$CACHE_DIR/info.png"
}

# Handle arguments
case "${1:-lock}" in
    lock)
        main
        ;;
    blur)
        # Just create blur without locking (for testing)
        create_blur
        echo "[*] Blur created at: $BLUR_IMG"
        ;;
    *)
        echo "Usage: $0 [lock|blur]"
        echo "  lock - Lock screen with info (default)"
        echo "  blur - Just create blur effect"
        exit 1
        ;;
esac
