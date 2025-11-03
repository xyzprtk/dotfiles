#!/bin/bash

# WiFi menu for Waybar using wofi and nmcli
# Dependencies: nmcli, wofi

# Get list of available Wi-Fi networks
wifi_list=$(nmcli -t -f active,ssid,signal dev wifi | awk -F: '
{
    icon = ($3 > 75) ? "󰤨" : ($3 > 50) ? "󰤥" : ($3 > 25) ? "󰤢" : "󰤟"
    if ($1 == "yes") {
        print "  " $2 "  (Connected)"
    } else {
        print icon "  " $2
    }
}')

# Add options for rescan & disconnect
wifi_list="🔄  Rescan\n$wifi_list\n🚫  Disconnect"

# Show menu
chosen=$(echo -e "$wifi_list" | wofi --dmenu --prompt "Wi-Fi Networks" --width 300 --height 400 --location center)

# Handle user selection
case "$chosen" in
    "🔄  Rescan")
        nmcli dev wifi rescan
        ~/.config/waybar/scripts/wofi-wifi.sh
        exit 0
        ;;
    "🚫  Disconnect")
        nmcli con down id "$(nmcli -t -f NAME con show --active | head -n1)"
        notify-send "Wi-Fi" "Disconnected from network"
        exit 0
        ;;
esac

# Extract SSID
ssid=$(echo "$chosen" | sed 's/^.*  //' | sed 's/ (Connected)//')

# Skip if nothing selected
[ -z "$ssid" ] && exit 0

# Check if already connected
if nmcli -t -f active,ssid dev wifi | grep -q "yes:$ssid"; then
    notify-send "Wi-Fi" "Already connected to $ssid"
    exit 0
fi

# Try connecting
if ! nmcli dev wifi connect "$ssid"; then
    # If password required
    pass=$(wofi --dmenu --password --prompt "Password for $ssid")
    nmcli dev wifi connect "$ssid" password "$pass" && \
        notify-send "Wi-Fi" "Connected to $ssid" || \
        notify-send "Wi-Fi" "Failed to connect"
else
    notify-send "Wi-Fi" "Connected to $ssid"
fi

