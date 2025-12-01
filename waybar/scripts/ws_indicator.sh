#!/usr/bin/env bash
# ws_indicator.sh — Poll Hyprland for the active workspace and emit JSON for Waybar.
# Safe JSON encoding (using jq) to avoid parse errors.

set -euo pipefail

# function: get active workspace id
get_active() {
  hyprctl monitors -j 2>/dev/null | jq -r '.[0].activeWorkspace.id' 2>/dev/null || echo "0"
}

# function: build output HTML (icons + names)
build_output() {
  local active="$1"
  local -A ICONS=(
    [1]="" [2]="󰈹" [3]="󰨞" [4]="" [5]=""
    [6]="󰎄" [7]="󰋩" [8]="󰊗" [9]="󰓇" [10]="󰝚"
  )
  local -A NAMES=(
    [1]="Terminal" [2]="Firefox" [3]="VSCode" [4]="Chrome"
    [5]="Spotify" [6]="Discord" [7]="Files" [8]="Mail"
    [9]="Docs" [10]="Misc"
  )

  local out=""
  for i in {1..10}; do
    if [ "$i" -eq "$active" ]; then
      out+="<span class=\"ws active\">${ICONS[$i]} ${NAMES[$i]}</span> "
    else
      out+="<span class=\"ws inactive\">${ICONS[$i]}</span> "
    fi
  done

  # Use jq to safely produce JSON (escape embedded quotes/newlines)
  printf '%s' "$out" | jq -R -s '{text: .}'
}

# Print initial state
prev_active=""
while true; do
  active=$(get_active)
  if [ "$active" != "$prev_active" ]; then
    build_output "$active"
    prev_active="$active"
  fi
  # poll interval (adjust if you want faster updates)
  sleep 1
done
