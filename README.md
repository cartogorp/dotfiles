# Dotfiles and Theming

This repository contains my personal dotfiles for configuring a consistent look and feel across Hyprland, Wofi, Waybar, Kitty, and Neovim.

---

## Color Palette

The theme is based on a dark, muted palette inspired by a holographic/oil-slick aesthetic with ThinkPad-style reds and subtle accent colors.

| Name               | Hex       | Usage                                  |
|--------------------|-----------|---------------------------------------|
| **background**       | #0e0b10   | Main background, deep obsidian purple-black |
| **surface**          | #18131e   | Slightly lifted background, surfaces  |
| **accent_red**       | #c7363f   | Selected borders, warnings, important highlights |
| **overlay**          | #221a28   | Overlay and hover states               |
| **muted_violet**     | #7e57c2   | Subtle purple highlight accents       |
| **muted_teal**       | #4db6ac   | Teal shimmer accents                   |
| **desaturated_mint** | #80cbc4   | Soft mint edge, main foreground       |
| **dusty_pink**       | #ce93d8   | Magenta shimmer accents                |
| **washed_amber**     | #ffb74d   | Muted amber warmth accents             |
| **indigo_fog**       | #5c6bc0   | Cool indigo blur accents               |

---

## File Structure

The configs are organized under this directory layout for easy management and use with GNU Stow:

.dotfiles/
├── hyprland/
│   └── .config/hypr/hyprland.conf
├── wofi/
│   └── .config/wofi/style.css
├── waybar/
│   └── .config/waybar/style.css
├── kitty/
│   └── .config/kitty/theme.conf
└── nvim/
    └── .config/nvim/
        ├── init.lua
        └── lua/config/colors.lua

---

## Branch Naming Conventions

| Prefix                  | Purpose                           | Example                         |
| ----------------------- | --------------------------------- | ------------------------------- |
| `feat/`                 | New features                      | `feat/waybar-unified-modules`   |
| `fix/`                  | Bug fixes                         | `fix/waybar-font-scaling`       |
| `chore/`                | Non-feature, non-fix tasks        | `chore/cleanup-waybar-css`      |
| `refactor/`             | Code/structure cleanup            | `refactor/waybar-layout`        |
| `style/`                | Visual-only changes (CSS, themes) | `style/waybar-theme-experiment` |
| `test/`                 | Adding or adjusting tests         | `test/dotfile-check-script`     |
| `docs/`                 | Documentation changes             | `docs/add-waybar-readme`        |
| `exp/`                  | Experimental ideas                | `exp/holographic-theme`         |

---

## Setup Instructions

1. Clone this repo:

    git clone git@github.com:yourusername/dotfiles.git ~/.dotfiles

2. Use GNU Stow to symlink desired configs into your home directory:

    cd ~/.dotfiles
    stow hyprland
    stow wofi
    stow waybar
    stow kitty
    stow nvim

3. Restart or reload relevant applications:

- Restart Hyprland or reload config with your keybind.
- Restart Wofi, Waybar, Kitty, and Neovim to apply new themes.

---

## Notes

- Customize font settings or additional options inside each config file.
- The Neovim colors.lua can be expanded to a full colorscheme or integrated into your existing config.
- The palette aims for a cohesive experience across terminal, compositor, launcher, bar, and editor.

