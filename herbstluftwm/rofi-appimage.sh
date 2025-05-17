#!/usr/bin/env bash

# Hard-coded directory containing AppImages
APPIMAGE_DIR="$HOME/Apps"  # Change this to your desired folder

# Check dependencies
if ! command -v rofi &> /dev/null || ! command -v appimage-run &> /dev/null; then
    notify-send "Error" "Missing required tools: rofi and/or appimage-run"
    exit 1
fi

# Check directory
if [ ! -d "$APPIMAGE_DIR" ]; then
    notify-send "Error" "AppImage directory not found: $APPIMAGE_DIR"
    exit 1
fi

# Get list of files (excluding hidden files and directories)
files=()
while IFS= read -r -d $'\0' file; do
    if [ -f "$file" ]; then
        files+=("$file")
    fi
done < <(find "$APPIMAGE_DIR" -maxdepth 1 -type f ! -name ".*" -print0)

# Show Rofi menu with just filenames
selected_name=$(printf "%s\n" "${files[@]}" | xargs -I{} basename "{}" | rofi -dmenu -s iggy -i -p "Run AppImage:")

# Find the full path of the selected file
if [ -n "$selected_name" ]; then
    selected_file="$APPIMAGE_DIR/$selected_name"
    if [ -f "$selected_file" ]; then
        appimage-run "$selected_file" &
    else
        notify-send "Error" "Invalid selection or file not found"
        exit 1
    fi
fi
