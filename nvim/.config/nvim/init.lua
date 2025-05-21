-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim...")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy.nvim with minimal plugins
require("lazy").setup({
	-- Example plugin, replace or add your own plugins here:
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- Add more plugins here!
})

-- Basic options to start with
vim.o.number = true -- show line numbers
vim.o.relativenumber = true -- relative line numbers
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.shiftwidth = 2 -- indentation amount for < and >
vim.o.tabstop = 2 -- number of spaces per tab
vim.o.smartindent = true -- autoindent new lines
vim.o.termguicolors = true -- enable 24-bit colors
vim.cmd.colorscheme("default") -- default colorscheme, change if you want
