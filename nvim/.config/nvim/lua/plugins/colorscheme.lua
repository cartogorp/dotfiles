-- Colorscheme configuration for Neovim
-- Matching kitty and oh-my-posh themes

return {
  -- Use catppuccin as the base theme engine with custom colors
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    lazy = false,    -- Load during startup
    event = "VimEnter", -- Load on startup
    
    opts = {
      -- Set the main flavor
      flavour = "mocha", -- Base flavor to customize
      
      -- Override palette colors with our own
      color_overrides = {
        mocha = {
          -- Match the kitty theme colors
          base      = "#18131e", -- Background
          mantle    = "#26202f", -- Secondary background
          surface0  = "#383145", -- Slightly lighter background (color8 from kitty)
          surface1  = "#383145", -- UI elements background
          surface2  = "#5e5e5e", -- UI elements hover
          text      = "#e3e3e3", -- Foreground
          subtext0  = "#c6c6c6", -- Subtle text
          subtext1  = "#e3e3e3", -- Less subtle text
          overlay0  = "#6c6c6c", -- Overlay text
          overlay1  = "#8f8f8f", -- Overlay text hover
          overlay2  = "#c6c6c6", -- Overlay text active
          
          -- Primary colors from kitty
          red       = "#c7363f", -- Red/Accent
          green     = "#98c379", -- Green from kitty
          yellow    = "#ffb74d", -- Yellow
          blue      = "#5c6bc0", -- Blue
          mauve     = "#ce93d8", -- Magenta
          lavender  = "#ce93d8", -- Light purple
          teal      = "#4db6ac", -- Darker cyan
          sapphire  = "#61afef", -- Light blue
          sky       = "#6496a9", -- Cyan/blue
          peach     = "#d19a66", -- Orange
          maroon    = "#c7363f", -- Darker red
          pink      = "#ce93d8", -- Light magenta
          flamingo  = "#c7363f", -- Light red
          rosewater = "#c7363f", -- Very light red
          crust     = "#15201f", -- Darkest background
        },
      },
      
      -- Integration settings
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
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
    
    -- Set up the colorscheme after loading
    config = function(_, opts)
      require("catppuccin").setup(opts)
      
      -- Force the colorscheme to apply immediately
      vim.schedule(function()
        vim.cmd.colorscheme("catppuccin")
      end)
      
      -- Apply custom highlight overrides
      -- This ensures consistency with core.highlights
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local hl = vim.api.nvim_set_hl
          
          -- Ensure Lazy.nvim UI uses our theme colors
          hl(0, "LazyNormal", { bg = "#18131e", fg = "#e3e3e3" })
          hl(0, "LazyButton", { bg = "#26202f", fg = "#e3e3e3" })
          hl(0, "LazyButtonActive", { bg = "#c7363f", fg = "#18131e", bold = true })
          
          -- Ensure terminal colors match kitty
          vim.g.terminal_color_0 = "#18131e"  -- Black
          vim.g.terminal_color_1 = "#c7363f"  -- Red
          vim.g.terminal_color_2 = "#98c379"  -- Green
          vim.g.terminal_color_3 = "#d19a66"  -- Yellow
          vim.g.terminal_color_4 = "#61afef"  -- Blue
          vim.g.terminal_color_5 = "#95669d"  -- Magenta
          vim.g.terminal_color_6 = "#6496a9"  -- Cyan
          vim.g.terminal_color_7 = "#e3e3e3"  -- White
          vim.g.terminal_color_8 = "#383145"  -- Bright Black
          vim.g.terminal_color_9 = "#c7363f"  -- Bright Red
          vim.g.terminal_color_10 = "#98c379" -- Bright Green
          vim.g.terminal_color_11 = "#d19a66" -- Bright Yellow
          vim.g.terminal_color_12 = "#61afef" -- Bright Blue
          vim.g.terminal_color_13 = "#95669d" -- Bright Magenta
          vim.g.terminal_color_14 = "#6496a9" -- Bright Cyan
          vim.g.terminal_color_15 = "#e3e3e3" -- Bright White
        end,
      })
      
      -- Set up terminal colors immediately
      vim.g.terminal_color_0 = "#18131e"  -- Black
      vim.g.terminal_color_1 = "#c7363f"  -- Red
      vim.g.terminal_color_2 = "#98c379"  -- Green
      vim.g.terminal_color_3 = "#d19a66"  -- Yellow
      vim.g.terminal_color_4 = "#61afef"  -- Blue
      vim.g.terminal_color_5 = "#95669d"  -- Magenta
      vim.g.terminal_color_6 = "#6496a9"  -- Cyan
      vim.g.terminal_color_7 = "#e3e3e3"  -- White
      vim.g.terminal_color_8 = "#383145"  -- Bright Black
      vim.g.terminal_color_9 = "#c7363f"  -- Bright Red
      vim.g.terminal_color_10 = "#98c379" -- Bright Green
      vim.g.terminal_color_11 = "#d19a66" -- Bright Yellow
      vim.g.terminal_color_12 = "#61afef" -- Bright Blue
      vim.g.terminal_color_13 = "#95669d" -- Bright Magenta
      vim.g.terminal_color_14 = "#6496a9" -- Bright Cyan
      vim.g.terminal_color_15 = "#e3e3e3" -- Bright White
    end,
  },
  
  -- Set up tokyonight as a fallback (already has good defaults)
  {
    "folke/tokyonight.nvim",
    priority = 900,
    lazy = true,
    enabled = false, -- Disable by default, enable if catppuccin fails
    opts = {
      style = "night",
      on_colors = function(colors)
        -- Override tokyonight colors to match our theme
        colors.bg = "#18131e"
        colors.bg_dark = "#15201f"
        colors.bg_float = "#26202f"
        colors.bg_highlight = "#383145"
        colors.bg_popup = "#26202f"
        colors.bg_sidebar = "#18131e"
        colors.fg = "#e3e3e3"
        colors.red = "#c7363f"
        colors.blue = "#5c6bc0"
        colors.yellow = "#ffb74d"
        colors.orange = "#d19a66"
        colors.green = "#98c379"
        colors.purple = "#ce93d8"
        colors.cyan = "#80cbc4"
        colors.comment = "#6c6c6c"
      end,
    },
  },
}

