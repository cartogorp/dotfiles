#!/usr/bin/env bash

# wallpaper.sh
# Script to manage wallpapers for Hyprland using hyprpaper
#
# Usage:
#   wallpaper.sh [OPTION]
#
# Options:
#   -Gn            Next global wallpaper
#   -Gp            Previous global wallpaper
#   -SG            Show wallpaper selection menu
#   -h, --help     Display this help and exit
#
# Dependencies:
#   - hyprctl: Hyprland control utility
#   - hyprpaper: Hyprland wallpaper utility
#   - wofi: Application launcher for menu
#   - notify-send: Notification utility

# Configuration
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_DIR="$HOME/.config/hypr"
HYPRPAPER_CONFIG="$CONFIG_DIR/hyprpaper.conf"
STATE_FILE="$CONFIG_DIR/.wallpaper_state"

# Supported image formats
EXTENSIONS=("jpg" "jpeg" "png" "gif" "bmp" "webp")

# Function to show help
show_help() {
    echo "Usage: $(basename "$0") [OPTION]"
    echo
    echo "Options:"
    echo "  -Gn            Next global wallpaper"
    echo "  -Gp            Previous global wallpaper"
    echo "  -SG            Show wallpaper selection menu"
    echo "  -h, --help     Display this help and exit"
    echo
    echo "Examples:"
    echo "  $(basename "$0") -Gn       # Switch to next wallpaper"
    echo "  $(basename "$0") -SG       # Show selection menu"
    exit 0
}

# Function to log messages
log_message() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" >> "$HOME/.cache/hypr/wallpaper.log"
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    
    for cmd in hyprctl hyprpaper wofi; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Error: Missing dependencies: ${missing_deps[*]}"
        log_message "Error: Missing dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# Function to scan for wallpapers
scan_wallpapers() {
    local wallpapers=()
    
    # Create wallpaper directory if it doesn't exist
    mkdir -p "$WALLPAPER_DIR"
    
    # Search for image files
    for ext in "${EXTENSIONS[@]}"; do
        while IFS= read -r -d '' file; do
            wallpapers+=("$file")
        done < <(find "$WALLPAPER_DIR" -type f -name "*.$ext" -print0 2>/dev/null)
    done
    
    # Check if any wallpapers were found
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found in $WALLPAPER_DIR"
        log_message "Error: No wallpapers found in $WALLPAPER_DIR"
        
        # If notify-send is available, show a notification
        if command -v notify-send &>/dev/null; then
            notify-send "Wallpaper Error" "No wallpapers found in $WALLPAPER_DIR" -u critical
        fi
        
        exit 1
    fi
    
    # Sort the wallpapers alphabetically
    readarray -t SORTED_WALLPAPERS < <(printf '%s\n' "${wallpapers[@]}" | sort)
    
    echo "${SORTED_WALLPAPERS[@]}"
}

# Function to get current wallpaper index
get_current_index() {
    local wallpapers=($1)
    local current_wallpaper
    
    # Read the current wallpaper from the state file
    if [ -f "$STATE_FILE" ]; then
        current_wallpaper=$(cat "$STATE_FILE")
    else
        # If no state file, create one with the first wallpaper
        current_wallpaper="${wallpapers[0]}"
        echo "$current_wallpaper" > "$STATE_FILE"
    fi
    
    # Find the index of the current wallpaper
    for i in "${!wallpapers[@]}"; do
        if [ "${wallpapers[$i]}" = "$current_wallpaper" ]; then
            echo "$i"
            return
        fi
    done
    
    # If not found, return 0 (first wallpaper)
    echo "0"
}

# Function to set wallpaper using hyprpaper
set_wallpaper() {
    local wallpaper=$1
    
    # Update hyprpaper.conf
    {
        echo "preload = $wallpaper"
        echo "wallpaper = ,\"$wallpaper\""
    } > "$HYPRPAPER_CONFIG"
    
    # Save the current wallpaper to the state file
    echo "$wallpaper" > "$STATE_FILE"
    
    # Restart hyprpaper
    killall hyprpaper 2>/dev/null
    hyprpaper &
    
    # Get the wallpaper filename for notification
    local wallpaper_name=$(basename "$wallpaper")
    
    # Show notification
    if command -v notify-send &>/dev/null; then
        notify-send -i "$wallpaper" "Wallpaper Changed" "Now using: $wallpaper_name" -u low
    fi
    
    log_message "Wallpaper set to: $wallpaper"
}

# Function to show next wallpaper
next_wallpaper() {
    local wallpapers=$(scan_wallpapers)
    local wallpaper_array=($wallpapers)
    local current_index=$(get_current_index "$wallpapers")
    local next_index=$(( (current_index + 1) % ${#wallpaper_array[@]} ))
    
    set_wallpaper "${wallpaper_array[$next_index]}"
}

# Function to show previous wallpaper
previous_wallpaper() {
    local wallpapers=$(scan_wallpapers)
    local wallpaper_array=($wallpapers)
    local current_index=$(get_current_index "$wallpapers")
    local prev_index=$(( (current_index - 1 + ${#wallpaper_array[@]}) % ${#wallpaper_array[@]} ))
    
    set_wallpaper "${wallpaper_array[$prev_index]}"
}

# Function to show wallpaper selection menu
show_wallpaper_menu() {
    local wallpapers=$(scan_wallpapers)
    local wallpaper_array=($wallpapers)
    local options=""
    
    # Build menu options with wallpaper names
    for wallpaper in "${wallpaper_array[@]}"; do
        local name=$(basename "$wallpaper")
        options+="$name\n"
    done
    
    # Show wofi menu
    local selected=$(echo -e "$options" | wofi --dmenu --prompt "Select Wallpaper" --width 500 --height 500 --cache-file /dev/null)
    
    # If a wallpaper was selected, set it
    if [ -n "$selected" ]; then
        for wallpaper in "${wallpaper_array[@]}"; do
            if [[ "$wallpaper" == *"$selected" ]]; then
                set_wallpaper "$wallpaper"
                break
            fi
        done
    fi
}

# Main function
main() {
    # Create cache directory
    mkdir -p "$HOME/.cache/hypr"
    
    # Check dependencies
    check_dependencies
    
    # Process arguments
    case "$1" in
        -Gn)
            next_wallpaper
            ;;
        -Gp)
            previous_wallpaper
            ;;
        -SG)
            show_wallpaper_menu
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Error: Invalid option: $1"
            echo "Try '$(basename "$0") --help' for more information."
            exit 1
            ;;
    esac
}

# Run the script
main "$@"

