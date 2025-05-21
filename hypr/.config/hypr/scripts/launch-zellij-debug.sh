#!/bin/bash

# Debug environment
export RUST_BACKTRACE=1
export ZELLIJ_LOG=debug

# Define paths
ZELLIJ="/home/cartogorp/.cargo/bin/zellij"
LOG_FILE="/tmp/zellij_launch.log"

# Log function
log() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

# Clean up
log "Cleaning up old sessions..."
pkill zellij || true
rm -rf /run/user/1000/zellij/
rm -rf /tmp/zellij-*

# Debug info
log "Starting debug info collection..."
log "Current PATH: $PATH"
log "Zellij location: $ZELLIJ"
"$ZELLIJ" --version 2>&1 | tee -a "$LOG_FILE"

# Launch Zellij
log "Launching Zellij..."
"$ZELLIJ" 2>&1 | tee -a "$LOG_FILE"

# If we get here, something went wrong
EXIT_CODE=$?
log "Zellij exited with code: $EXIT_CODE"
echo "Press Enter to close..."
read -r
