-- General settings
lvim.log.level = "warn"
lvim.format_on_save = true
vim.cmd("set timeoutlen=150")
vim.opt.relativenumber = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 20
vim.opt.scrolloff = 3
lvim.leader = "space"

-- Key mappings
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<BS>"] = ":Telescope find_files<CR>"
lvim.keys.normal_mode[";"] = ":Telescope buffers<CR>"
lvim.keys.normal_mode[";;"] = ":Telescope treesitter<CR>"
lvim.keys.normal_mode["="] = ":Telescope live_grep<CR>"
lvim.keys.normal_mode["=="] = ":Telescope current_buffer_fuzzy_find<CR>"

-- Additional Plugins
lvim.plugins = {
  { "andrewstuart/vim-kubernetes" },
  { "cespare/vim-toml" },
  { "mechatroner/rainbow_csv" },
  { "plasticboy/vim-markdown",    dependencies = { "godlygeek/tabular" } },
  { "ggandor/leap.nvim" },
  {
    "nvim-orgmode/orgmode",
    config = function()
      require('orgmode').setup {}
    end
  },
  {
    "Maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end
  },
  -- colorschemes
  { "marko-cerovac/material.nvim" },
}
require('leap').add_default_mappings()

-- Custom settings
require("robyoung.which-key")
require("robyoung.orgmode")
require("robyoung.snippets")
require("robyoung.colourscheme")

-- LSP Settings
-- vim.diagnostic.config({ virtual_text = false })
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "ruff",
    args = { "--unfixable=F841" },
    filetypes = { "python" }
  },
  { name = "black",    filetypes = { "python" } },
  { name = "prettier", filetypes = { "typescript" } },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "ruff" },
  { name = "shellcheck" },
}
