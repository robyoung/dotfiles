-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- colorschemes
        { "marko-cerovac/material.nvim" },
        { "tanvirtin/monokai.nvim" },
        -- Auto-completion engine
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
                "hrsh7th/cmp-buffer", -- buffer auto-completion
                "hrsh7th/cmp-path", -- path auto-completion
                "hrsh7th/cmp-cmdline", -- cmdline auto-completion
            },
            config = function()
                require("config.nvim-cmp")
            end,
        },
        -- Code snippet engine
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
        -- LSP manager
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        -- Org mode
        {
          'nvim-orgmode/orgmode',
          event = 'VeryLazy',
          ft = { 'org' },
          config = function()
            -- Setup orgmode
            require('notes')

            -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
            -- add ~org~ to ignore_install
            -- require('nvim-treesitter.configs').setup({
            --   ensure_installed = 'all',
            --   ignore_install = { 'org' },
            -- })
          end,
        },
        {
            "nvim-orgmode/telescope-orgmode.nvim",
            event = "VeryLazy",
            dependencies = {
              "nvim-orgmode/orgmode",
              "nvim-telescope/telescope.nvim",
            },
            config = function()
              -- TODO: Move this somewhere else
              require("telescope").load_extension("orgmode")

              vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
              vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
              vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
            end,
        },
        -- 
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
          "folke/which-key.nvim",
          event = "VeryLazy",
          opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
          },
          keys = {
            {
              "<leader>?",
              function()
                require("which-key").show({ global = false })
              end,
              desc = "Buffer Local Keymaps (which-key)",
            },
          },
        }
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})
