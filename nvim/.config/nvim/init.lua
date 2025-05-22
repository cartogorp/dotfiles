-- Set leader keys first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.lazy")

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.termguicolors = true
vim.cmd.colorscheme("default")

