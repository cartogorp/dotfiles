-- ~/.config/nvim/lua/core/clipboard.lua
vim.g.clipboard = {
  name = "wl-clipboard (Wayland)",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --primary --type text/plain",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline --primary",
  },
  cache_enabled = true,
}

