lvim.colorscheme = "material"
vim.g.material_style = "deep ocean"

-- See: ~/.local/share/lunarvim/site/pack/lazy/opt/material.nvim/lua/material/colors/init.lua
require("material").setup({
  contrast = {
    sidebars = true,
    cursor_line = true,
  },
  high_visibility = {
    darker = true,
  },
  lualine_style = "stealth",
  custom_colors = function(colors)
    colors.editor.accent       = "#bbbbbb"
    colors.editor.bg_alt       = nil       -- fold background
    colors.editor.disabled     = "#868B9D" -- fold foreground
    colors.editor.line_numbers = "#6B6F81" -- left hand line numbers
    colors.syntax.comments     = "#767B8D" -- comments
  end
})
