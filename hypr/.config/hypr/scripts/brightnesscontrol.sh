#!/usr/bin/env bash

# brightnesscontrol.sh
# Script to control screen brightness for Hyprland
#
# Usage:
#   brightnesscontrol.sh [i|d]
#
# Parameters:
#   i       Increase brightness
#   d       Decrease brightness
#
# Examples:
#   brightnesscontrol.sh i    # Increase brightness
#   brightnesscontrol.sh d    # Decrease brightness

# Brightness change step (in percent)
STEP=5

# Get script name
script_name=$(basename "$0")

# Function to show usage
usage() {
    echo "Usage: $script_name [i|d]"
    echo "  i: Increase brightness"
    echo "  d: Decrease brightness"
    exit 1
}

# Function to display notification with brightness level
notify_brightness() {
    local brightness=$1
    local icon="display-brightness-symbolic"
    local title="Brightness"
    
    # Create brightness bar
    bar=$(seq -s "█" $(($brightness / 5)) | sed 's/[0-9]//g')
    
    notify-send -i "$icon" "$title" "$brightness% $bar" -r 5555 -u low
}

# Function to control brightness
control_brightness() {
    local action=$1
    local current
    local max
    local brightness
    
    case $action in
        i) # Increase brightness
            brightnessctl set "${STEP}%+" -q
            ;;
        d) # Decrease brightness
            brightnessctl set "${STEP}%-" -q
            ;;
        *)
            echo "Error: Invalid action for brightness control"
            usage
            ;;
    esac
    
    # Get current brightness percent
    current=$(brightnessctl get)
    max=$(brightnessctl max)
    brightness=$((current * 100 / max))
    
    # Send notification
    notify_brightness "$brightness"
}

# Check for dependencies
if ! command -v brightnessctl &>/dev/null; then
    echo "Error: brightnessctl is not installed. Please install it to use this script."
    exit 1
fi

if ! command -v notify-send &>/dev/null; then
    echo "Error: notify-send is not installed. Please install it to use this script."
    exit 1
fi

# Check if argument is provided
if [ $# -lt 1 ]; then
    usage
fi

# Call control function with the provided argument
control_brightness "$1"

exit 0

