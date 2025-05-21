#!/bin/bash
# Log file for debugging
exec 1> >(tee -a /tmp/zellij-launch.log)
exec 2>&1

echo "[$(date)] Starting Zellij launch script"

# Clean up any existing sessions
pkill zellij || true
rm -rf /run/user/1000/zellij/
sleep 1

echo "[$(date)] Cleaned up old sessions"

# Launch zellij with catch for errors
if ! ZELLIJ_LOG=debug /usr/bin/zellij; then
    echo "[$(date)] Zellij failed to start"
    echo "Press Enter to close..."
    read -r
fi
