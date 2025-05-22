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
