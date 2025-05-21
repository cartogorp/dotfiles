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

-- setup lazy.nvim with minimal plugins
require("lazy").setup({
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

  -- Telescope and dependencies
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- Lualine statusline
  { "nvim-lualine/lualine.nvim" },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- LSP support
  { "neovim/nvim-lspconfig" },
})

-- Basic options
vim.o.number = true -- show line numbers
vim.o.relativenumber = true -- relative line numbers
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- indentation amount for < and >
vim.o.tabstop = 2 -- number of spaces per tab
vim.o.smartindent = true -- autoindent new lines
vim.o.termguicolors = true -- enable 24-bit colors
vim.cmd.colorscheme("default") -- default colorscheme

