#!/usr/bin/env python3
import os
import tomli

# Config - adjust these paths if needed
PALETTE_PATH = "/home/cartogorp/.dotfiles/themes/.config/themes/cartogorp-custom/cartogorp-custom.toml"
OUTPUT_BASE = "/home/cartogorp/.dotfiles/themes/cartogorp-custom"

# Optional global alpha for transparency, 0.0 to 1.0 or None
GLOBAL_ALPHA = 0.85

def hex_to_rgba(hex_color, alpha=None):
    hex_color = hex_color.lstrip('#')
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    if alpha is None:
        return f"#{hex_color}"
    else:
        return f"rgba({r}, {g}, {b}, {alpha})"

def load_palette(path):
    with open(path, "rb") as f:
        return tomli.load(f)

def ensure_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)

# Generator functions per target

def gen_nvim(palette):
    # Example: generate palette.lua with primary and neutral colors
    out_dir = os.path.join(OUTPUT_BASE, "nvim")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "palette.lua")
    with open(path, "w") as f:
        f.write("-- Generated palette.lua\n")
        f.write("local palette = {\n")
        for key, val in palette.get("primary", {}).items():
            f.write(f'  ["primary_{key}"] = "{val}",\n')
        for key, val in palette.get("neutral", {}).items():
            f.write(f'  ["neutral_{key}"] = "{val}",\n')
        f.write("}\n\nreturn palette\n")

def gen_kitty(palette):
    out_dir = os.path.join(OUTPUT_BASE, "kitty")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "cartogorp-custom.conf")
    with open(path, "w") as f:
        f.write("# Generated kitty config\n")
        f.write(f"background {palette['surface']['a0']}\n")
        f.write(f"foreground {palette['neutral']['a0']}\n")
        # ANSI colors 0-15 example
        for i in range(16):
            key = f"ansi_{i}"
            val = palette.get("ansi", {}).get(str(i), None)
            if val:
                f.write(f"color{i} {val}\n")

def gen_hyprland(palette):
    out_dir = os.path.join(OUTPUT_BASE, "hyprland")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "colors.conf")
    with open(path, "w") as f:
        f.write("# Generated hyprland colors.conf\n")
        # Example: background color with alpha transparency if possible
        bg = palette['surface']['a0']
        if GLOBAL_ALPHA is not None:
            bg = hex_to_rgba(bg, GLOBAL_ALPHA)
        f.write(f"general:background = {bg}\n")
        # Add more colors as needed

def gen_waybar(palette):
    out_dir = os.path.join(OUTPUT_BASE, "waybar")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "style.css")
    with open(path, "w") as f:
        f.write("/* Generated Waybar CSS */\n")
        bg = palette['surface']['a0']
        if GLOBAL_ALPHA is not None:
            bg = hex_to_rgba(bg, GLOBAL_ALPHA)
        f.write(f".background {{ background-color: {bg}; }}\n")

def gen_oh_my_posh(palette):
    out_dir = os.path.join(OUTPUT_BASE, "oh-my-posh")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "cartogorp-custom.omp.json")
    with open(path, "w") as f:
        f.write("{\n")
        f.write('  "colors": {\n')
        for key, val in palette.get("primary", {}).items():
            f.write(f'    "{key}": "{val}",\n')
        f.write('    "background": "' + palette['surface']['a0'] + '"\n')
        f.write("  }\n")
        f.write("}\n")

def gen_zellij(palette):
    out_dir = os.path.join(OUTPUT_BASE, "zellij")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "theme.kdl")
    with open(path, "w") as f:
        f.write("// Generated Zellij theme.kdl\n")
        f.write('theme {\n')
        for key, val in palette.get("primary", {}).items():
            f.write(f'  {key} "{val}"\n')
        f.write('}\n')

def gen_wofi(palette):
    out_dir = os.path.join(OUTPUT_BASE, "wofi")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "style.css")
    with open(path, "w") as f:
        f.write("/* Generated Wofi style.css */\n")
        bg = palette['surface']['a0']
        if GLOBAL_ALPHA is not None:
            bg = hex_to_rgba(bg, GLOBAL_ALPHA)
        f.write(f".window {{ background-color: {bg}; }}\n")

def gen_hyprlock(palette):
    out_dir = os.path.join(OUTPUT_BASE, "hyprlock")
    ensure_dir(out_dir)
    path = os.path.join(out_dir, "hyprlock.conf")
    with open(path, "w") as f:
        f.write("# Generated hyprlock.conf\n")
        bg = palette['surface']['a0']
        if GLOBAL_ALPHA is not None:
            bg = hex_to_rgba(bg, GLOBAL_ALPHA)
        f.write(f"background_color={bg}\n")

# Main function
def main():
    palette = load_palette(PALETTE_PATH)
    gen_nvim(palette)
    gen_kitty(palette)
    gen_hyprland(palette)
    gen_waybar(palette)
    gen_oh_my_posh(palette)
    gen_zellij(palette)
    gen_wofi(palette)
    gen_hyprlock(palette)
    print("Generated all theme files successfully.")

if __name__ == "__main__":
    main()

