#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Create wallpapers directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Get list of valid image files (non-empty files with image extensions)
wallpapers=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -size +10k)

if [ -z "$wallpapers" ]; then
    notify-send "No valid wallpapers found" "Please add wallpapers to $WALLPAPER_DIR"
    exit 1
fi

# Create a list of just the filenames for wofi
wallpaper_names=$(basename -a $wallpapers)

# Use wofi to pick a wallpaper
selected=$(echo "$wallpaper_names" | wofi --dmenu --prompt "Select wallpaper" --height 200)

if [ ! -z "$selected" ]; then
    wallpaper_path="$WALLPAPER_DIR/$selected"
    
    # Check if file exists and is not empty
    if [ -f "$wallpaper_path" ] && [ -s "$wallpaper_path" ]; then
        # Set the wallpaper with swww
        swww img "$wallpaper_path" \
            --transition-type wipe \
            --transition-angle 30 \
            --transition-duration 1

        # Notify user
        notify-send "Wallpaper changed" "Set to: $selected"
    else
        notify-send "Error" "Selected wallpaper file is invalid"
    fi
fi

