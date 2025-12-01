#!/usr/bin/env bash
# ~/.config/waybar/scripts/ws_name.sh

ACTIVE_WS=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id' 2>/dev/null || echo "0")

case "$ACTIVE_WS" in
  1) ICON=""; NAME="Terminal" ;;
  2) ICON="󰈹"; NAME="Firefox" ;;
  3) ICON="󰨞"; NAME="VSCode" ;;
  4) ICON=""; NAME="Chrome" ;;
  5) ICON=""; NAME="Spotify" ;;
  6) ICON="󰎄"; NAME="Discord" ;;
  7) ICON="󰋩"; NAME="Files" ;;
  8) ICON="󰊗"; NAME="Mail" ;;
  9) ICON="󰓇"; NAME="Docs" ;;
  10) ICON="󰝚"; NAME="Misc" ;;
  *) ICON="󰧞"; NAME="Unknown" ;;
esac

# Use jq to safely emit JSON
jq -n --arg text "$ICON $NAME" --arg tooltip "$NAME" '{text:$text, tooltip:$tooltip}'
