--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true

-- colour scheme
lvim.colorscheme = "gruvbox"
vim.o.background = "dark"
vim.g.gruvbox_contrast_dark = "hard"

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
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"
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
lvim.builtin.which_key.mappings["t"] = {
  name = "+tabs",
  n = { "<cmd>tabnext<cr>", "next" },
  p = { "<cmd>tabprevious<cr>", "previous" },
}
lvim.builtin.which_key.mappings["o"] = {
  name = "+org mode",
  ["*"] = { "toggle heading" },
  ["'"] = { "edit special" },
  ["$"] = { "archive" },
  a = { "agenda" },
  A = { "archive" },
  c = { "capture" },
  r = { "refile" },
  o = { "open" },
  e = { "export" },
  t = { "set tags" },
  K = { "move headline up" },
  J = { "move headline down" },
  x = { 
    name = "clock",
    i = { "in" },
    o = { "out" },
    q = { "cancel" },
    j = { "goto" },
    e = { "effort estimate" },
  },
  i = {
    name = "insert",
    d = { "deadline" },
    s = { "schedule" },
    h = { "headline" },
    t = { "TODO" },
    T = { "TODO here" },
    ["."] = { "date under cursor" },
    ["!"] = { "inactive date under cursor" },
  }
}

require("which-key").register({
  c = {
    name = "org change",
    i = { 
      name = "change",
      d = { "change date" },
      R = { "priority up" },
      r = { "priority down" },
      t = { "TODO next" },
      T = { "TODO previous" },
    }
  },
  g = {
    ["?"] = { "org mode help" },
    ["{"] = { "org parent" },
  }
}, {mode = "n", prefix = "", preset = true})

-- Additional Plugins
lvim.plugins = {
  {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}},
  {"glepnir/indent-guides.nvim"},
  {"andrewstuart/vim-kubernetes"},
  {"cespare/vim-toml"},
  {"plasticboy/vim-markdown", requires={"godlygeek/tabular"}},
  {"robyoung/orgmode", branch = "ignore-past-non-todo", config = function()
        require('orgmode').setup{}
  end},
}

require("orgmode").setup_ts_grammar()

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
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
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.disable = { "org" }
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "org" }

require("orgmode").setup({
  org_agenda_files = {"~/Notes/**/*"},
  org_default_notes_file = "~/Notes/Inbox.org",
  org_todo_keywords = {"TODO", "DOING", "BLOCKED", "|", "DONE", "ABANDONED"},
})


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
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "isort", filetypes = {"python"} },
  { exe = "black", filetypes = {"python"} },
  { exe = "prettier", filetypes = {"typescript"} },
}


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
