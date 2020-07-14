set runtimepath^=~/vim-dev
let &packpath = &runtimepath
source ~/.vimrc
" Make navigation into and out of Neovim terminal splits nicer.
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
source ~/.config/nvim/config/lsp.vim
source ~/.config/nvim/config/gdb.vim
set foldlevel=99
