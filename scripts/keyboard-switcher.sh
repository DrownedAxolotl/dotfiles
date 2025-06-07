#!/bin/bash

# Show rofi menu with layout options
choice=$(echo -e "US\nCyrilic\nLatin" | rofi -theme ~/.config/rofi-themes/rounded-nord-dark.rasi -dmenu -p "Keyboard layout:")

# Set the appropriate keyboard layout based on the choice
case $choice in
    "US")
        setxkbmap us
        notify-send "Keyboard Layout" "Set to US (qwerty)"
        ;;
    "Cyrilic")
        setxkbmap -layout rs
        notify-send "Keyboard Layout" "Set to Serbian (Cyrilic)"
        ;;
    "Latin")
        setxkbmap rs latin
        notify-send "Keyboard Layout" "Set to Serbian (Latin)"
        ;;
    *)
        # No valid selection made
        exit 1
        ;;
esac
