#!/bin/bash

# Get song info using playerctl (supports Spotify, G4Music, etc.)
title=$(playerctl metadata xesam:title 2>/dev/null)
artist=$(playerctl metadata xesam:artist 2>/dev/null)

# If nothing is playing
if [ -z "$title" ]; then
  echo '{"text": " No music playing", "class": "inactive"}'
  exit 0
fi

# Simple animated visualizer (changes dynamically)
bars=$(awk -v seed=$RANDOM 'BEGIN {
  srand(seed);
  s="▁▂▃▄▅▆▇█";
  for(i=0;i<10;i++) printf "%s", substr(s, int(rand()*length(s))+1, 1);
  
}')

# Combine text + animation
echo "{\"text\": \"$bars  $title — $artist\", \"class\": \"active\"}"
