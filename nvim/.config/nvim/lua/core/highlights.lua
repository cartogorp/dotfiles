local palette = require("core.palette")

local function set_highlights()
  local hl = vim.api.nvim_set_hl
  local p = palette

  -- Universal base groups
  hl(0, "Normal",         { fg = p.desaturated_mint, bg = p.background })
  hl(0, "NormalNC",       { fg = p.desaturated_mint, bg = p.background })
  hl(0, "Comment",        { fg = p.muted_teal, italic = true })
  hl(0, "LineNr",         { fg = p.muted_teal })
  hl(0, "CursorLineNr",   { fg = p.washed_amber, bold = true })
  hl(0, "CursorLine",     { bg = p.surface })
  hl(0, "Visual",         { bg = p.overlay })
  hl(0, "StatusLine",     { fg = p.background, bg = p.dusty_pink, bold = true })
  hl(0, "VertSplit",      { fg = p.overlay })

  -- Floating windows
  hl(0, "NormalFloat",    { bg = p.background })
  hl(0, "FloatBorder",    { fg = p.muted_teal, bg = p.background })

  -- Popup / Menu
  hl(0, "Pmenu",          { fg = p.desaturated_mint, bg = p.overlay })
  hl(0, "PmenuSel",       { fg = p.background, bg = p.dusty_pink, bold = true })

  -- Telescope
  hl(0, "TelescopeNormal",     { fg = p.desaturated_mint, bg = p.surface })
  hl(0, "TelescopeSelection",  { fg = p.background, bg = p.washed_amber, bold = true })
  hl(0, "TelescopeMatching",   { fg = p.dusty_pink, bold = true })
  hl(0, "TelescopeBorder",     { fg = p.muted_violet, bg = p.background })

  -- Neo-tree
  hl(0, "NeoTreeNormal",         { fg = p.desaturated_mint, bg = p.background })
  hl(0, "NeoTreeCursorLine",     { bg = p.surface })
  hl(0, "NeoTreeFileNameHidden", { fg = p.muted_teal, italic = true })

  -- Diagnostics & Git
  hl(0, "DiagnosticError",       { fg = p.accent_red })
  hl(0, "DiagnosticWarn",        { fg = p.washed_amber })
  hl(0, "DiagnosticInfo",        { fg = p.indigo_fog })
  hl(0, "DiagnosticHint",        { fg = p.muted_teal })
  hl(0, "GitSignsAdd",           { fg = p.muted_teal })
  hl(0, "GitSignsChange",        { fg = p.washed_amber })
  hl(0, "GitSignsDelete",        { fg = p.accent_red })
end

return {
  set_highlights = set_highlights,
}

