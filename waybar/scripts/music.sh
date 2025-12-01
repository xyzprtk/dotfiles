#!/bin/bash

# List of preferred players in priority order
preferred_players=("spotify" "g4music")

# Find an active player
for player in "${preferred_players[@]}"; do
  if playerctl -p "$player" status &>/dev/null; then
    active_player="$player"
    break
  fi
done

# If no preferred player is active
if [ -z "$active_player" ]; then
  echo '{"text": " No music playing", "class": "inactive"}'
  exit 0
fi

# Get metadata
title=$(playerctl -p "$active_player" metadata xesam:title 2>/dev/null)
artist=$(playerctl -p "$active_player" metadata xesam:artist 2>/dev/null)

# If metadata is empty
if [ -z "$title" ]; then
  echo '{"text": " No music playing", "class": "inactive"}'
  exit 0
fi

# Animated visualizer
bars=$(awk -v seed=$RANDOM 'BEGIN {
  srand(seed);
  s="▁▂▃▄▅▆▇█";
  for(i=0;i<10;i++) printf "%s", substr(s, int(rand()*length(s))+1, 1);
}')

# Set clickable command for Waybar
if [ "$active_player" = "spotify" ]; then
  onclick_command="spotify"
elif [ "$active_player" = "g4music" ]; then
  onclick_command="g4music"
fi

# Output JSON with click action for Waybar
echo "{\"text\": \"$bars  $title — $artist\", \"class\": \"active\", \"tooltip\": \"$artist — $title\", \"on-click\": \"$onclick_command\"}"
