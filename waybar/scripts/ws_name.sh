#!/bin/bash

# Get the active workspace ID
ACTIVE_WS=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id')

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

# Output JSON to Waybar
echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$NAME\"}"

