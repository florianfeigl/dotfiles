#!/bin/bash

chosen=$(printf "🔒 \tSperren\n⏾ \tLogout\n🔁 \tNeustart\n⏻ \tAusschalten" | fuzzel --dmenu --width=35 --lines=4 --prompt "Aktion wählen")

case "$chosen" in
  "🔒 Sperren") hyprlock ;;
  "⏾ Logout") hyprctl dispatch exit ;;
  "🔁 Neustart") systemctl reboot ;;
  "⏻ Ausschalten") systemctl poweroff ;;
  *) exit 1 ;;
esac

