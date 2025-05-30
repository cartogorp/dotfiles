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

-- Load your custom highlight overrides after plugins/colorscheme are loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Wait a bit to ensure colorscheme has been applied by plugins
    vim.defer_fn(function()
      require("core.highlights").set_highlights()
    end, 100)
  end,
})

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

