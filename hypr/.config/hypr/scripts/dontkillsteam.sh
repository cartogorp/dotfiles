#!/usr/bin/env bash

# dontkillsteam.sh
# Script to safely handle window closing operations by minimizing Steam windows
# instead of closing them completely.
#
# Usage:
#   Bind this script to window close keybindings (Super+Q, Alt+F4)
#
# Purpose:
#   Steam often runs games as child processes. Closing Steam accidentally can
#   cause games to close unexpectedly. This script minimizes Steam windows
#   instead of closing them to prevent accidental disruption of gaming sessions.

# Log file for debugging
LOG_FILE="$HOME/.cache/hypr/dontkillsteam.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log_message() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" >> "$LOG_FILE"
}

# Function to check if a string contains "steam" (case insensitive)
is_steam_window() {
    local window_info=$1
    echo "$window_info" | grep -i "steam" > /dev/null
    return $?
}

# Main function to handle window closing
handle_window_close() {
    # Get information about the active window
    local window_info
    window_info=$(hyprctl activewindow -j 2>&1)
    
    # Check if there's an active window
    if [[ "$window_info" == *"No window"* ]]; then
        log_message "No active window found."
        return 0
    fi
    
    # Extract class, title, and address for logging
    local window_class
    local window_title
    local window_address
    
    window_class=$(echo "$window_info" | jq -r '.class // "unknown"')
    window_title=$(echo "$window_info" | jq -r '.title // "unknown"')
    window_address=$(echo "$window_info" | jq -r '.address // "unknown"')
    
    log_message "Active window: Class='$window_class', Title='$window_title', Address='$window_address'"
    
    # Check if it's a Steam window
    if is_steam_window "$window_class" || is_steam_window "$window_title"; then
        log_message "Steam window detected. Minimizing instead of closing."
        
        # Minimize the window instead of closing
        hyprctl dispatch movetoworkspacesilent special "$window_address"
        
        # Optional: Show a notification
        if command -v notify-send &>/dev/null; then
            notify-send "Steam Minimized" "Steam was minimized instead of closed" -u low
        fi
    else
        log_message "Non-Steam window. Closing normally."
        
        # Close the window normally
        hyprctl dispatch killactive
    fi
}

# Check if hyprctl is available
if ! command -v hyprctl &>/dev/null; then
    log_message "Error: hyprctl not found. This script requires Hyprland."
    echo "Error: hyprctl not found. This script requires Hyprland."
    exit 1
fi

# Check if jq is available
if ! command -v jq &>/dev/null; then
    log_message "Error: jq not found. Please install jq to use this script."
    echo "Error: jq not found. Please install jq to use this script."
    exit 1
fi

# Handle window close
handle_window_close

exit 0

