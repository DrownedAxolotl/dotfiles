#!/bin/bash

# Show rofi menu with layout options
choice=$(echo -e "Exit\nSuspend\nPower Off" | rofi -theme ~/.config/rofi-themes/rounded-nord-dark.rasi -dmenu -p "Turn off computer:")

case $choice in
    "Suspend")
        systemctl suspend
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    *)
        # No valid selection made
        exit 1
        ;;
esac
