#!/usr/bin/env bash

# screenshot.sh
# Script to take screenshots in Hyprland using grim, slurp and wl-clipboard
#
# Usage:
#   screenshot.sh [s|sf|m|p]
#
# Parameters:
#   s     Take a screenshot of a selected area
#   sf    Take a screenshot of a selected area (frozen screen)
#   m     Take a screenshot of the active monitor
#   p     Take a screenshot of all monitors
#
# Dependencies:
#   - grim: Screenshot utility for Wayland
#   - slurp: Region selector for Wayland
#   - wl-clipboard: Clipboard utility for Wayland
#   - notify-send: Notification utility (part of libnotify)
#   - hyprctl: Hyprland control utility
#   - jq: JSON processor

# Get script name
script_name=$(basename "$0")

# Screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Function to show usage
usage() {
    echo "Usage: $script_name [s|sf|m|p]"
    echo "  s:  Take a screenshot of a selected area"
    echo "  sf: Take a screenshot of a selected area (frozen screen)"
    echo "  m:  Take a screenshot of the active monitor"
    echo "  p:  Take a screenshot of all monitors"
    exit 1
}

# Function to display notification
notify_screenshot() {
    local file=$1
    local title="Screenshot Captured"
    local message="Screenshot saved to $file"
    
    # Show notification with preview
    notify-send -i "$file" "$title" "$message" -u normal
}

# Function to take a screenshot of a selected area
screenshot_selection() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local file="$SCREENSHOT_DIR/screenshot_${timestamp}.png"
    
    # Use grim and slurp to take the screenshot of the selected area
    grim -g "$(slurp)" "$file"
    
    # Check if the file was created
    if [ -f "$file" ]; then
        # Copy to clipboard
        wl-copy < "$file"
        
        # Show notification
        notify_screenshot "$file"
        
        echo "Screenshot saved to $file"
    else
        notify-send "Screenshot Failed" "No area selected or operation cancelled" -u critical
        echo "Screenshot failed: No area was selected or the operation was cancelled"
        exit 1
    fi
}

# Function to take a screenshot of a selected area with frozen screen
screenshot_selection_frozen() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local file="$SCREENSHOT_DIR/screenshot_${timestamp}.png"
    local temp_file="/tmp/screenshot_temp.png"
    
    # Take a full screenshot first
    grim "$temp_file"
    
    # Use slurp with the full screenshot as background
    grim -g "$(slurp -b 00000000 -c 00000000 < "$temp_file")" "$file"
    
    # Remove the temporary file
    rm "$temp_file"
    
    # Check if the file was created
    if [ -f "$file" ]; then
        # Copy to clipboard
        wl-copy < "$file"
        
        # Show notification
        notify_screenshot "$file"
        
        echo "Screenshot saved to $file"
    else
        notify-send "Screenshot Failed" "No area selected or operation cancelled" -u critical
        echo "Screenshot failed: No area was selected or the operation was cancelled"
        exit 1
    fi
}

# Function to take a screenshot of the active monitor
screenshot_monitor() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local file="$SCREENSHOT_DIR/screenshot_${timestamp}.png"
    
    # Get the active monitor using hyprctl
    local monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
    
    if [ -z "$monitor" ]; then
        notify-send "Screenshot Failed" "Could not identify active monitor" -u critical
        echo "Screenshot failed: Could not identify active monitor"
        exit 1
    fi
    
    # Take a screenshot of the active monitor
    grim -o "$monitor" "$file"
    
    # Check if the file was created
    if [ -f "$file" ]; then
        # Copy to clipboard
        wl-copy < "$file"
        
        # Show notification
        notify_screenshot "$file"
        
        echo "Screenshot saved to $file"
    else
        notify-send "Screenshot Failed" "Could not capture monitor" -u critical
        echo "Screenshot failed: Could not capture monitor"
        exit 1
    fi
}

# Function to take a screenshot of all monitors
screenshot_all() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local file="$SCREENSHOT_DIR/screenshot_${timestamp}.png"
    
    # Take a screenshot of all monitors
    grim "$file"
    
    # Check if the file was created
    if [ -f "$file" ]; then
        # Copy to clipboard
        wl-copy < "$file"
        
        # Show notification
        notify_screenshot "$file"
        
        echo "Screenshot saved to $file"
    else
        notify-send "Screenshot Failed" "Could not capture screen" -u critical
        echo "Screenshot failed: Could not capture screen"
        exit 1
    fi
}

# Check for dependencies
for cmd in grim slurp wl-copy notify-send hyprctl jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed. Please install it to use this script."
        exit 1
    fi
done

# Check if argument is provided
if [ $# -lt 1 ]; then
    usage
fi

# Process the argument
case "$1" in
    s)
        screenshot_selection
        ;;
    sf)
        screenshot_selection_frozen
        ;;
    m)
        screenshot_monitor
        ;;
    p)
        screenshot_all
        ;;
    *)
        usage
        ;;
esac

exit 0

