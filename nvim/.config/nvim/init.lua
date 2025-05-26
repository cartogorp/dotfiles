-- Set leader keys first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.lazy")
require("core.clipboard")

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.termguicolors = true

-- Set your colorscheme (this will be overridden by LazyVim if using themes)
vim.cmd.colorscheme("default")

-- Load your custom highlight overrides
require("core.highlights").set_highlights()

-- Reapply them if a plugin/theme changes the colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    require("core.highlights").set_highlights()
  end,
})

-- Enable GitHub Copilot in commit message buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd("Copilot enable")
  end,
})

