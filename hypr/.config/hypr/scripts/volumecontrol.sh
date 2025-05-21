#!/usr/bin/env bash

# volumecontrol.sh
# Script to control volume for Hyprland
#
# Usage:
#   volumecontrol.sh -o [i|d|m]    # Control output volume (increase, decrease, mute)
#   volumecontrol.sh -i [i|d|m]    # Control input volume (increase, decrease, mute)
#
# Examples:
#   volumecontrol.sh -o i    # Increase output volume
#   volumecontrol.sh -o d    # Decrease output volume
#   volumecontrol.sh -o m    # Toggle mute for output
#   volumecontrol.sh -i m    # Toggle mute for input (microphone)

# Output volume step size
STEP=5

# Get script name
script_name=$(basename "$0")

# Function to show usage
usage() {
    echo "Usage: $script_name -o [i|d|m] | -i [i|d|m]"
    echo "  -o: Control output volume"
    echo "  -i: Control input volume"
    echo "  Followed by:"
    echo "    i: Increase volume"
    echo "    d: Decrease volume"
    echo "    m: Toggle mute"
    exit 1
}

# Function to display notification with volume level
notify_volume() {
    local device=$1
    local volume=$2
    local muted=$3
    local icon="audio-volume-high-symbolic"
    local title="Volume"
    
    if [ "$muted" == "yes" ]; then
        icon="audio-volume-muted-symbolic"
        notify-send -i "$icon" "$title" "Muted" -r 5555 -u low
        return
    fi
    
    if [ "$volume" -le 33 ]; then
        icon="audio-volume-low-symbolic"
    elif [ "$volume" -le 66 ]; then
        icon="audio-volume-medium-symbolic"
    fi
    
    if [ "$device" == "input" ]; then
        icon="microphone-sensitivity-high-symbolic"
        title="Microphone"
        if [ "$muted" == "yes" ]; then
            icon="microphone-sensitivity-muted-symbolic"
        fi
    fi
    
    # Create volume bar
    bar=$(seq -s "█" $(($volume / 5)) | sed 's/[0-9]//g')
    
    notify-send -i "$icon" "$title" "$volume% $bar" -r 5555 -u low
}

# Function to control output volume
control_output_volume() {
    local action=$1
    local volume
    local muted
    
    case $action in
        i) # Increase volume
            pamixer -i $STEP
            ;;
        d) # Decrease volume
            pamixer -d $STEP
            ;;
        m) # Toggle mute
            pamixer -t
            ;;
        *)
            echo "Error: Invalid action for output volume"
            usage
            ;;
    esac
    
    # Get current volume and mute status
    volume=$(pamixer --get-volume)
    muted=$(pamixer --get-mute && echo "yes" || echo "no")
    
    # Send notification
    notify_volume "output" "$volume" "$muted"
}

# Function to control input volume
control_input_volume() {
    local action=$1
    local volume
    local muted
    
    case $action in
        i) # Increase volume
            pamixer --default-source -i $STEP
            ;;
        d) # Decrease volume
            pamixer --default-source -d $STEP
            ;;
        m) # Toggle mute
            pamixer --default-source -t
            ;;
        *)
            echo "Error: Invalid action for input volume"
            usage
            ;;
    esac
    
    # Get current volume and mute status for input
    volume=$(pamixer --default-source --get-volume)
    muted=$(pamixer --default-source --get-mute && echo "yes" || echo "no")
    
    # Send notification
    notify_volume "input" "$volume" "$muted"
}

# Check for dependencies
if ! command -v pamixer &>/dev/null; then
    echo "Error: pamixer is not installed. Please install it to use this script."
    exit 1
fi

if ! command -v notify-send &>/dev/null; then
    echo "Error: notify-send is not installed. Please install it to use this script."
    exit 1
fi

# Check if arguments are provided
if [ $# -lt 2 ]; then
    usage
fi

# Parse arguments
case $1 in
    -o)
        control_output_volume "$2"
        ;;
    -i)
        control_input_volume "$2"
        ;;
    *)
        usage
        ;;
esac

exit 0

