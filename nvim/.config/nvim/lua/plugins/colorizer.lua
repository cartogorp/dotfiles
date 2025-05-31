-- ~/.config/nvim/lua/plugins/colorizer.lua
return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      filetypes = { "*", "!lazy" }, -- Disable in Lazy.nvim UI
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        mode = "background", -- "background" | "foreground" | "virtualtext"
        virtualtext = "■",
      },
    })
  end,
}

