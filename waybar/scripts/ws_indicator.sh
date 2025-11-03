#!/bin/bash

# Listen for Hyprland workspace changes and output JSON continuously
print_ws() {
    ACTIVE=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id')

    declare -A ICONS=(
        [1]=""
        [2]="󰈹"
        [3]="󰨞"
        [4]=""
        [5]=""
        [6]="󰎄"
        [7]="󰋩"
        [8]="󰊗"
        [9]="󰓇"
        [10]="󰝚"
    )

    declare -A NAMES=(
        [1]="Terminal"
        [2]="Firefox"
        [3]="VSCode"
        [4]="Chrome"
        [5]="Spotify"
        [6]="Discord"
        [7]="Files"
        [8]="Mail"
        [9]="Docs"
        [10]="Misc"
    )

    OUTPUT=""
    for i in {1..10}; do
        if [ "$i" -eq "$ACTIVE" ]; then
            OUTPUT+="<span class=\"ws active\">${ICONS[$i]} ${NAMES[$i]}</span> "
        else
            OUTPUT+="<span class=\"ws inactive\">${ICONS[$i]}</span> "
        fi
    done

    echo "{\"text\": \"$OUTPUT\"}"
}

# Print initial state
print_ws

# Listen for workspace changes in real-time
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | \
while read -r line; do
    if [[ "$line" == "workspace>>"* ]]; then
        print_ws
    fi
done

