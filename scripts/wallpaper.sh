#!/bin/bash

WALLPAPER_DIRECTORY=/home/prtk/Pictures/Wallpapers
WALLPAPER=$(find "$WALLPAPER_DIRECTORY" -type f | shuf -n 1)

# Preload the selected wallpaper
hyprctl hyprpaper preload "$WALLPAPER"

# Apply the wallpaper to all connected monitors
for MONITOR in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
    hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
done

# Give it a moment to apply
sleep 1

# Unload any unused wallpapers to save memory
hyprctl hyprpaper unload unused

notify-send "Wallpaper Changed!" "$(basename "$WALLPAPER")"


