-- general
--
lvim.log.level = "warn"
lvim.format_on_save = true

-- Colourscheme
lvim.colorscheme = "material"
vim.g.material_style = "deep ocean"

vim.cmd("set timeoutlen=150")
vim.opt.relativenumber = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 20
vim.opt.scrolloff = 3

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<BS>"] = ":Telescope find_files<CR>"
lvim.keys.normal_mode[";"] = ":Telescope buffers<CR>"
lvim.keys.normal_mode[";;"] = ":Telescope treesitter<CR>"
lvim.keys.normal_mode["="] = ":Telescope live_grep<CR>"
lvim.keys.normal_mode["=="] = ":Telescope current_buffer_fuzzy_find<CR>"
lvim.autocommands._formatoptions = {}
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.

-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

require("robyoung.which-key")
require("robyoung.orgmode")
require("robyoung.snippets")

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
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "Maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end
  },
  -- colorschemes
  { "lunarvim/colorschemes" },
  { "ellisonleao/gruvbox.nvim",   dependencies = { "rktjmp/lush.nvim" } },
  { "marko-cerovac/material.nvim" },
}
require('leap').add_default_mappings()

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
    colors.editor.bg = "#000000"
    colors.editor.line_numbers = "#777777"
    colors.syntax.comments = "#999999"
    colors.editor.selection = "#404040"
  end
})

require("cmp").setup({
  sources = { { name = "orgmode" } },
  preselect = require("cmp").PreselectMode.None
})


-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
  "org",
  "markdown",
  "hcl",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.disable = { "org" }
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "org" }


-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   {
--     exe = "prettier",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
--
require("lspconfig").beancount.setup {
  cmd = { 'beancount-language-server', '--stdio' },
  init_options = {
    journal_file = '/home/robyoung/Accounts/personal.beancount',
    python_path = 'python3',
  },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "black" },
--   {
--     exe = "eslint_d",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "javascriptreact" },
--   },
-- }
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pylyzer" })
vim.diagnostic.config({ virtual_text = false })
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
-- lvim.format_on_save = false


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
