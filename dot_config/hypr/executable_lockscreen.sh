#!/bin/bash
#
# Hyprland/Sway Lockscreen with Information Display
# Features: Time, Date, Calendar, Battery, Network Status
# Dependencies: hyprlock, grim, imagemagick (convert), playerctl (optional)
#

set -e

# Colors (Catppuccin Macchiato)
BG="#24273a"
TEXT="#cad3f5"
ACCENT="#c6a0f6"
SUBTEXT="#6e738d"

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
get_bluetooth() {
    local bt=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    [ "$bt" = "yes" ] && echo "On" || echo "Off"
}
get_music() {
    if command -v playerctl &>/dev/null; then
        playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo "No playback"
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

# Create lockscreen config on the fly
create_hyprlock_config() {
    local time=$(get_time)
    local date=$(get_date)
    local battery=$(get_battery)
    local network=$(get_network)
    local bluetooth=$(get_bluetooth)
    local music=$(get_music)
    
    cat > "$CACHE_DIR/hyprlock.conf" << EOF
# Generated lockscreen config
background {
    monitor =
    path = $BLUR_IMG
    blur_passes = 3
    blur_size = 8
    noise = 0.0117
    contrast = 1.0
    brightness = 0.8
    vibrancy = 0.2
    vibrancy_darkness = 0.2
}

# Time (large, center)
label {
    monitor =
    text = $time
    text_align = center
    font_size = 120
    font_family = IosevkaTerm Nerd Font
    position = 0, 80
    halign = center
    valign = center
    shadow_passes = 3
    shadow_size = 8
    color = rgb($ACCENT)
}

# Date (under time)
label {
    monitor =
    text = $date
    text_align = center
    font_size = 18
    font_family = IosevkaTerm Nerd Font
    position = 0, -80
    halign = center
    valign = center
    color = rgb($TEXT)
}

# Battery info (bottom right)
label {
    monitor =
    text = 🔋 $battery
    text_align = right
    font_size = 14
    font_family = IosevkaTerm Nerd Font
    position = -30, -30
    halign = right
    valign = bottom
    color = rgb($SUBTEXT)
}

# Network info (bottom left)
label {
    monitor =
    text = 📡 $network
    text_align = left
    font_size = 14
    font_family = IosevkaTerm Nerd Font
    position = 30, -30
    halign = left
    valign = bottom
    color = rgb($SUBTEXT)
}

# Bluetooth status (bottom center)
label {
    monitor =
    text = 🔵 BT: $bluetooth
    text_align = center
    font_size = 14
    font_family = IosevkaTerm Nerd Font
    position = 0, -30
    halign = center
    valign = bottom
    color = rgb($SUBTEXT)
}
EOF

    # Add music info if playing
    if [ -n "$music" ] && [ "$music" != "No playback" ]; then
        cat >> "$CACHE_DIR/hyprlock.conf" << EOF

# Now Playing (top center)
label {
    monitor =
    text = 🎵 $music
    text_align = center
    font_size = 14
    font_family = IosevkaTerm Nerd Font
    position = 0, 30
    halign = center
    valign = top
    color = rgb($ACCENT)
}
EOF
    fi
}

# Lock the screen
lock_screen() {
    echo "[*] Locking screen..."
    
    # Use hyprlock if available
    if command -v hyprlock &>/dev/null; then
        hyprlock -c "$CACHE_DIR/hyprlock.conf"
    # Fallback to swaylock for Sway
    elif command -v swaylock &>/dev/null; then
        # swaylock doesn't support dynamic config, use simple version
        swaylock -f -c "$BG" &
        # Show info in a simple way (optional, requires a notification daemon)
        sleep 1
    else
        echo "[!] No lockscreen utility found!"
        exit 1
    fi
}

# Main
main() {
    echo "[*] Starting lockscreen..."
    
    # Pause music if playing
    if command -v playerctl &>/dev/null; then
        playerctl pause 2>/dev/null || true
    fi
    
    # Create blur background
    create_blur
    
    # Generate config with current system info
    create_hyprlock_config
    
    # Lock the screen
    lock_screen
    
    # Cleanup
    rm -f "$SNAPSHOT_IMG"
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
    config)
        # Just create config for inspection
        create_hyprlock_config
        echo "[*] Config created at: $CACHE_DIR/hyprlock.conf"
        cat "$CACHE_DIR/hyprlock.conf"
        ;;
    *)
        echo "Usage: $0 [lock|blur|config]"
        echo "  lock   - Lock screen with info (default)"
        echo "  blur   - Just create blur effect"
        echo "  config - Generate and show config"
        exit 1
        ;;
esac
