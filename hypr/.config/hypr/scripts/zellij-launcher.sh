#!/bin/bash

# First, create a new terminal window that will stay open
kitty --class "zellij-terminal" --title "Zellij Terminal" -e bash -c "
    # Set up environment
    export PATH=\"\$HOME/.cargo/bin:\$PATH\"
    export TERM=xterm-256color
    
    # Clean up existing sessions
    pkill zellij
    rm -rf /run/user/1000/zellij/
    
    # Print debug info
    echo \"Starting Zellij...\"
    echo \"Using: \$(which zellij)\"
    echo \"Version: \$(zellij --version)\"
    
    # Launch Zellij
    \$HOME/.cargo/bin/zellij || {
        echo \"Zellij exited with code: \$?\"
        echo \"Press Enter to close...\"
        read
    }
"
