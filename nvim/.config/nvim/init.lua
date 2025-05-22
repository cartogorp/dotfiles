require("core.lazy")
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
  })
end

-- setup lazy.nvim with minimal plugins

-- Basic options
vim.o.number = true -- show line numbers
vim.o.relativenumber = true -- relative line numbers
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- indentation amount for < and >
vim.o.tabstop = 2 -- number of spaces per tab
vim.o.smartindent = true -- autoindent new lines
vim.o.termguicolors = true -- enable 24-bit colors
vim.cmd.colorscheme("default") -- default colorscheme

