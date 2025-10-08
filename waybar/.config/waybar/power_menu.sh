#!/bin/bash

chosen=$(printf "🔒 \tSperren\n⏾ \tLogout\n🔁 \tNeustart\n⏻ \tAusschalten" | wofi --dmenu --width 300 --height 200 --prompt "Aktion wählen")

case "$chosen" in
  "🔒 Sperren") hyprlock ;;
  "⏾ Logout") hyprctl dispatch exit ;;
  "🔁 Neustart") systemctl reboot ;;
  "⏻ Ausschalten") systemctl poweroff ;;
  *) exit 1 ;;
esac

