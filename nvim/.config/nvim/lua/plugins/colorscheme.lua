-- ~/.config/nvim/lua/plugins/colorscheme.lua

-- Ensure Lua can find your theme palette
local theme_path = vim.fn.expand("~/.dotfiles/themes/.config")
package.path = package.path
  .. ";" .. theme_path .. "/?/init.lua"
  .. ";" .. theme_path .. "/?.lua"

-- Load generated theme palette
local ok, palette = pcall(require, "themes.cartogorp-custom.nvim.palette")
if not ok then
  vim.notify("Failed to load theme palette", vim.log.levels.ERROR)
  return
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          base     = palette.surface.a0,
          mantle   = palette.tonal_surface.a10,
          crust    = palette.primary.a50,
          surface0 = palette.surface.a10,
          surface1 = palette.surface.a20,
          surface2 = palette.surface.a30,
          text     = palette.text.primary,
          subtext0 = palette.text.secondary,
          subtext1 = palette.text.primary,
          overlay0 = palette.neutral.a20,
          overlay1 = palette.neutral.a30,
          overlay2 = palette.neutral.a10,

          red      = palette.danger.a0,
          green    = palette.success.a0,
          yellow   = palette.warning.a0,
          blue     = palette.info.a0,
          mauve    = palette.accent.a0,
          lavender = palette.accent.a0,
          teal     = palette.primary.a10,
          sapphire = palette.extra.blue,
          sky      = palette.primary.a0,
          peach    = palette.extra.yellow,
          maroon   = palette.danger.a10,
          pink     = palette.accent.a20,
          flamingo = palette.danger.a0,
          rosewater= palette.danger.a0,
        },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local hl = vim.api.nvim_set_hl
          hl(0, "LazyNormal", { bg = palette.surface.a0, fg = palette.text.primary })
          hl(0, "LazyButton", { bg = palette.tonal_surface.a10, fg = palette.text.primary })
          hl(0, "LazyButtonActive", { bg = palette.danger.a0, fg = palette.surface.a0, bold = true })

          -- Apply terminal colors from extra or fallback
          for i = 0, 15 do
            vim.g["terminal_color_" .. i] = palette.extra[i] or palette.text.primary
          end
        end,
      })
    end,
  },
}

