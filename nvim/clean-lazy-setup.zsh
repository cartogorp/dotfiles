#!/usr/bin/env zsh

# Path to your Neovim init.lua file
INIT_LUA="$HOME/.dotfiles/nvim/.config/nvim/init.lua"
BACKUP_FILE="${INIT_LUA}.bak"

echo "📁 Editing: $INIT_LUA"
echo "📦 Backing up original file to: $BACKUP_FILE"

# Backup original file
cp "$INIT_LUA" "$BACKUP_FILE"

# Remove lazy.nvim bootstrap and setup block
awk '
  /vim\.fn\.stdpath\("data"\)/ { skipping = 1 }
  skipping && /\}\)/ { skipping = 0; next }
  skipping { next }

  /require\("lazy"\)\.setup\s*\(\s*\{/ { skipping = 1 }
  skipping && /^\s*\}\s*\)/ { skipping = 0; next }
  skipping { next }

  /require\("lazy"\)/ { next }

  { print }
' "$BACKUP_FILE" > "$INIT_LUA"

echo "✅ Cleaned lazy.nvim bootstrap and setup block from init.lua"

