#!/usr/bin/env zsh

DOTFILES_NVIM="$HOME/.dotfiles/nvim/.config/nvim"
PLUGINS_DIR="$DOTFILES_NVIM/lua/plugins"
CORE_DIR="$DOTFILES_NVIM/lua/core"
INIT_FILE="$DOTFILES_NVIM/init.lua"
LAZY_FILE="$CORE_DIR/lazy.lua"

mkdir -p "$PLUGINS_DIR" "$CORE_DIR"

# Define your plugins here exactly as in your old lazy.lua
typeset -A plugins
plugins=(
  treesitter '{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }'
  plenary '"nvim-lua/plenary.nvim"'
  telescope '{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } }'
  neotree '{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" } }'
  lualine '"nvim-lualine/lualine.nvim"'
  cmp '{ "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" } }'
  lspconfig '"neovim/nvim-lspconfig"'
)

echo "\n🌱 Creating plugin spec files in: $PLUGINS_DIR\n"

for name key in ${(kv)plugins}; do
  FILE="$PLUGINS_DIR/$name.lua"
  if [[ -e "$FILE" ]]; then
    echo "⚠️  Skipping existing file: $name.lua"
  else
    echo "return $key" >| "$FILE"
    echo "✅ Created: $name.lua"
  fi
done

echo "\n🧹 Cleaning old lazy.nvim setup block in $INIT_FILE..."

# Remove existing lazy.nvim block from init.lua (adjust sed for your system)
sed -i.bak '/require("lazy").setup/,/})/d' "$INIT_FILE"
sed -i '' '/vim.opt.rtp:prepend/d' "$INIT_FILE"
sed -i '' '/lazypath/d' "$INIT_FILE"
sed -i '' '/git clone .*lazy.nvim/d' "$INIT_FILE"
sed -i '' '/bootstrap lazy.nvim/d' "$INIT_FILE"

echo "✅ Cleaned old lazy.nvim setup."

echo "\n📦 Creating lazy loader file in: $LAZY_FILE"

cat > "$LAZY_FILE" <<'EOF'
-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin specs from lua/plugins/*.lua
local plugins = {}
local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.globpath(plugin_dir, "*.lua", false, true)

for _, file in ipairs(files) do
  local name = file:match("([^/\\]+)%.lua$")
  if name and name ~= "init" then
    local ok, plugin = pcall(require, "plugins." .. name)
    if ok then
      table.insert(plugins, plugin)
    else
      vim.notify("Failed to load plugin: " .. name, vim.log.levels.WARN)
    end
  end
end

require("lazy").setup(plugins)
EOF

echo "\n✏️ Updating init.lua to use core.lazy..."

# Remove any existing require("lazy") line
sed -i '' '/require("lazy")/d' "$INIT_FILE"

# Add require("core.lazy") at the top if not already there
if ! grep -q 'require("core.lazy")' "$INIT_FILE"; then
  echo 'require("core.lazy")' | cat - "$INIT_FILE" >| "$INIT_FILE.tmp" && mv "$INIT_FILE.tmp" "$INIT_FILE"
  echo "✅ Added require('core.lazy') to init.lua"
fi

echo "\n🎉 Done! Your plugins are split and lazy setup moved to core.lazy."

