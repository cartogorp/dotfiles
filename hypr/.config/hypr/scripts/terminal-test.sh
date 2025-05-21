#!/bin/bash

# Launch a basic terminal first
kitty --title "Terminal Test" -e bash -c "
    echo Terminal launched successfully
    echo Press Enter to try launching Zellij...
    read

    # Now try to launch Zellij
    ZELLIJ_LOG=debug /usr/bin/zellij
    
    echo
    echo \"Zellij exited with code: \$?\"
    echo \"Press Enter to close...\"
    read
"
