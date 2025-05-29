local palette = require("themes.cartogorp-custom.nvim.palette")

local function set_highlights()
  local hl = vim.api.nvim_set_hl
  local p = palette

  -- Universal base groups
  hl(0, "Normal",         { fg = p.primary_a0, bg = p.neutral_a50 })
  hl(0, "NormalNC",       { fg = p.primary_a0, bg = p.neutral_a50 })
  hl(0, "Comment",        { fg = p.primary_a10, italic = true })
  hl(0, "LineNr",         { fg = p.primary_a10 })
  hl(0, "CursorLineNr",   { fg = p.primary_a0, bold = true })
  hl(0, "CursorLine",     { bg = p.neutral_a40 })
  hl(0, "Visual",         { bg = p.neutral_a30 })
  hl(0, "StatusLine",     { fg = p.neutral_a50, bg = p.primary_a10, bold = true })
  hl(0, "VertSplit",      { fg = p.neutral_a30 })

  -- Floating windows
  hl(0, "NormalFloat",    { bg = p.neutral_a50 })
  hl(0, "FloatBorder",    { fg = p.primary_a10, bg = p.neutral_a50 })

  -- Popup / Menu
  hl(0, "Pmenu",          { fg = p.primary_a0, bg = p.neutral_a30 })
  hl(0, "PmenuSel",       { fg = p.neutral_a50, bg = p.primary_a10, bold = true })

  -- Telescope
  hl(0, "TelescopeNormal",     { fg = p.primary_a0, bg = p.neutral_a40 })
  hl(0, "TelescopeSelection",  { fg = p.neutral_a50, bg = p.primary_a0, bold = true })
  hl(0, "TelescopeMatching",   { fg = p.primary_a10, bold = true })
  hl(0, "TelescopeBorder",     { fg = p.primary_a20, bg = p.neutral_a50 })

  -- Neo-tree
  hl(0, "NeoTreeNormal",         { fg = p.primary_a0, bg = p.neutral_a50 })
  hl(0, "NeoTreeCursorLine",     { bg = p.neutral_a40 })
  hl(0, "NeoTreeFileNameHidden", { fg = p.primary_a10, italic = true })

  -- Diagnostics & Git
  hl(0, "DiagnosticError",       { fg = p.primary_a0 })  -- No direct accent_red equivalent
  hl(0, "DiagnosticWarn",        { fg = p.primary_a0 })
  hl(0, "DiagnosticInfo",        { fg = p.primary_a20 })
  hl(0, "DiagnosticHint",        { fg = p.primary_a10 })
  hl(0, "GitSignsAdd",           { fg = p.primary_a10 })
  hl(0, "GitSignsChange",        { fg = p.primary_a0 })
  hl(0, "GitSignsDelete",        { fg = p.primary_a0 })  -- No direct accent_red equivalent
end

return {
  set_highlights = set_highlights,
}

