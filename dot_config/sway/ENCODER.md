# Keychron V1 Encoder Configuration

## Overview

The Keychron V1 has a rotating encoder knob that can be configured for:
- **Rotate**: Volume control (±5% per step)
- **Press**: Toggle mute

## How It Works

The `encoder-daemon.sh` script monitors input events from your Keychron keyboard and maps:
- `POINTER_MOTION_UNACCELERATED` with `REL_WHEEL` axis → Volume adjustment
- `BUTTON_PRESS` events → Mute toggle

## Setup

### Prerequisites

- `libinput-tools` (Debian) or `libinput` (Arch) - for `libinput debug-events`
- `wpctl` (already installed with wireplumber)
- Sway window manager

### Installation

1. The daemon starts automatically when Sway loads (see `sway/config`)
2. Ensure `encoder-daemon.sh` is executable:
   ```bash
   chmod +x ~/.config/sway/encoder-daemon.sh
   ```

### Testing

To test if the encoder is detected:
```bash
libinput list-devices | grep -i keychron
```

To manually monitor events:
```bash
libinput debug-events
# Then rotate the encoder and press it - you should see events
```

## Troubleshooting

### Daemon not responding

1. Check if the daemon is running:
   ```bash
   ps aux | grep encoder-daemon
   ```

2. Check logs (if running systemd):
   ```bash
   journalctl -u sway -f
   ```

3. Verify the device is detected:
   ```bash
   libinput list-devices | grep Keychron
   ```

### Volume not changing

- Ensure `wpctl` is available: `which wpctl`
- Test manually: `wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+`
- Check if PipeWire/WirePlumber is running

### Mute toggle not working

- Check mute state: `wpctl get-volume @DEFAULT_AUDIO_SINK@`
- Test toggle: `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle`

## Customization

Edit `encoder-daemon.sh` to change:

- **Volume step**: Change `VOLUME_STEP=5` to a different value
- **Device detection**: Modify `find_keychron()` if your device isn't found
- **Button action**: Replace `wpctl set-mute` with other commands

## Future Enhancements

- Detect long-press vs short-press for different actions
- Multi-device support (multiple encoders)
- Track press duration for hold-to-adjust volumes quickly

## Notes

- The daemon restarts on Sway reload (`$mod+Shift+C`)
- Works only on Debian/Sway setup (no Arch/Hyprland equivalent for now)
