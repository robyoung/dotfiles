-- Key mappings
vim.keymap.set('n', "<C-s>", ":w<cr>")
vim.keymap.set('n', "<BS>", ":Telescope find_files<CR>")
vim.keymap.set('n', ";", ":Telescope buffers<CR>")
vim.keymap.set('n', ";;", ":Telescope treesitter<CR>")
vim.keymap.set('n', "=", ":Telescope live_grep<CR>")
vim.keymap.set('n', "==", ":Telescope current_buffer_fuzzy_find<CR>")

