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
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = false }
    end
  },
  { "mechatroner/rainbow_csv" },
  { "plasticboy/vim-markdown", dependencies = { "godlygeek/tabular" } },
  { "ggandor/leap.nvim" },
  { "towolf/vim-helm" },
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
  { "github/copilot.vim" },
  -- colorschemes
  { "marko-cerovac/material.nvim" },
}
require('leap').add_default_mappings()

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

local cmp = require("cmp")
local copilot_callback = function(fallback)
  cmp.mapping.abort()
  local copilot_keys = vim.fn["copilot#Accept"]()
  if copilot_keys ~= "" then
    vim.api.nvim_feedkeys(copilot_keys, "i", true)
  else
    fallback()
  end
end
lvim.builtin.cmp.mapping["<C-e>"] = copilot_callback
lvim.builtin.cmp.mapping["<C-y>"] = copilot_callback

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
