return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    -- Custom colors to match kitty and oh-my-posh
    local colors = {
      bg = "#18131e",         -- Dark background
      fg = "#e3e3e3",         -- Foreground
      dark_bg = "#26202f",    -- Secondary background
      blue = "#5c6bc0",       -- Blue
      cyan = "#80cbc4",       -- Cyan
      green = "#98c379",      -- Green
      orange = "#d19a66",     -- Orange
      magenta = "#ce93d8",    -- Magenta
      red = "#c7363f",        -- Red/Accent
      yellow = "#ffb74d",     -- Yellow
      gray = "#383145",       -- Slightly lighter background
    }
    
    -- Custom theme that matches our palette
    local theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
        b = { fg = colors.fg, bg = colors.gray },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
      },
      command = {
        a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
      },
      inactive = {
        a = { fg = colors.fg, bg = colors.dark_bg, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
    }
    
    -- Customize lualine components
    local mode_map = {
      n = " NORMAL",
      i = " INSERT",
      v = " VISUAL",
      [''] = " V-BLOCK",
      V = " V-LINE",
      c = " COMMAND",
      R = " REPLACE",
      t = " TERMINAL",
    }
    
    -- Get filename with icon
    local filename = {
      'filename',
      icon = '󰉋',
      path = 1, -- Show relative path
      symbols = {
        modified = ' ●',
        readonly = ' ',
        unnamed = '[No Name]',
      }
    }

    -- Custom git component to match oh-my-posh style
    local branch = {
      'branch',
      icon = '',
      color = { fg = colors.yellow, gui = 'bold' },
    }
    
    local diff = {
      'diff',
      symbols = { added = ' ', modified = ' ', removed = ' ' },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.yellow },
        removed = { fg = colors.red },
      },
    }
    
    -- Configure lualine with a layout similar to oh-my-posh
    return {
      options = {
        theme = theme,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'NvimTree', 'neo-tree', 'dashboard', 'Outline', 'alpha' },
          winbar = { 'NvimTree', 'neo-tree', 'dashboard', 'Outline', 'alpha' },
        },
        globalstatus = true,
      },
      sections = {
        -- Left side
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return mode_map[vim.fn.mode()] or str
            end,
          },
        },
        lualine_b = {
          {
            -- username (similar to oh-my-posh)
            function()
              return ' ' .. os.getenv('USER')
            end,
            color = { fg = colors.magenta, gui = 'bold' },
          },
          filename,
        },
        lualine_c = {
          branch,
          diff,
        },
        
        -- Right side
        lualine_x = {
          {
            'diagnostics',
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.cyan },
              hint = { fg = colors.green },
            },
          },
          { 'filetype', colored = true, icon_only = false },
        },
        lualine_y = {
          { 'progress', color = { fg = colors.cyan, gui = 'bold' } },
          { 'location', color = { fg = colors.fg, gui = 'bold' } },
        },
        lualine_z = {
          {
            -- Time (matching oh-my-posh)
            function()
              return ' ' .. os.date('%H:%M')
            end,
            color = { fg = colors.yellow, gui = 'bold' },
          },
        },
      },
      -- Set up inactive windows
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      -- Add tabline configuration
      tabline = {},
      -- Add winbar configuration
      winbar = {},
      -- Add inactive winbar configuration
      inactive_winbar = {},
      -- Enable extensions
      extensions = { 'neo-tree', 'lazy', 'mason', 'trouble', 'toggleterm' },
    }
  end,
}
