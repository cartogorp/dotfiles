#!/usr/bin/env zsh

# Theme name and base directories
THEME_NAME="cartogorp-custom"
GENERATED_DIR="$HOME/.dotfiles/themes/.config/themes/$THEME_NAME/generated"
DOTFILES="$HOME/.dotfiles"

# Declare an associative array for app target paths
typeset -A TARGET_PATHS
TARGET_PATHS=(
  kitty      "kitty/.config/kitty/theme.conf"
  nvim       "nvim/.config/nvim/lua/themes/${THEME_NAME}.lua"
  hyprland   "hypr/.config/hypr/themes/${THEME_NAME}.conf"
  waybar     "waybar/.config/waybar/themes/${THEME_NAME}.css"
  zellij     "zellij/.config/zellij/themes/${THEME_NAME}.kdl"
  wofi       "wofi/.config/wofi/style.css"
  hyprlock   "hyprlock/.config/hyprlock/themes/${THEME_NAME}.conf"
  oh-my-posh "oh-my-posh/.config/oh-my-posh/themes/${THEME_NAME}.omp.json"
)

echo "🔗 Linking generated theme files to ~/.dotfiles..."

for app in "${(@k)TARGET_PATHS}"; do
  src_ext="${TARGET_PATHS[$app]##*.}"
  src_file="${GENERATED_DIR}/${app}.${src_ext}"
  dest_file="${DOTFILES}/${TARGET_PATHS[$app]}"

  # Create parent directory if needed
  mkdir -p "${dest_file:h}"

  # Create or update the symlink
  ln -sf "$src_file" "$dest_file"

  echo "✅ Linked: $src_file → $dest_file"
done

echo "\n✨ All theme links created in dotfiles. Run 'stow <app>' for any changes to take effect."

