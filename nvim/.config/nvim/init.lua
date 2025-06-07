-- Set leader keys first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load lazy.nvim plugin manager
require("core.lazy")

-- Set up shared clipboard support
require("core.clipboard")

-- Basic editor options
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.termguicolors = true

-- Load theme colors from generated palette.lua
local ok, palette = pcall(require, "themes.cartogorp-custom.nvim.palette")
if ok then
  for k, v in pairs(palette) do
    vim.g["theme_" .. k] = v
  end
else
  vim.notify("❌ Failed to load generated theme palette", vim.log.levels.ERROR)
end

-- Apply custom highlights after colorscheme is loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      require("core.highlights").set_highlights()
    end, 100)
  end,
})

-- Reapply highlights if colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    require("core.highlights").set_highlights()
  end,
})

-- Enable GitHub Copilot in git commit messages
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd("Copilot enable")
  end,
})

