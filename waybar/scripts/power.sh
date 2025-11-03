#!/bin/bash

# Power menu script for Waybar (Hyprland)
# Requires: rofi (or wofi if you change below)

# Define menu options
options="⏻  Power Off\n🔄  Reboot\n🚪  Log Out\n❌  Cancel"

# Use rofi to display the menu
chosen=$(echo -e "$options" | wofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    "⏻  Power Off")
        systemctl poweroff
        ;;
    "🔄  Reboot")
        systemctl reboot
        ;;
    "🚪  Log Out")
        hyprctl dispatch exit 0
        ;;
    *)
        exit 0
        ;;
esac

