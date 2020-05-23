" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" fix arrow keys in insert mode
imap <ESC>oA <ESC>ki
imap <ESC>oB <ESC>ji
imap <ESC>oC <ESC>li
imap <ESC>oD <ESC>hi

set encoding=utf-8
set fileencoding=utf-8
set signcolumn=yes
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:plug_url_format = 'git@github.com:%s.git'

" vim-plug https://github.com/junegunn/vim-plug
if has("nvim")
  call plug#begin('~/.local/share/nvim/plugged')
  " Provides :Files, :Buffers
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Used
  Plug 'airblade/vim-gitgutter'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'gcmt/taboo.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fugitive'
  "Plug 'tpope/vim-rhubarb'  " github stuff for fugitive
  "Plug 'tpope/vim-vinegar'  " slightly improves netrw, meh
  Plug 'lepture/vim-jinja'
  Plug 'rust-lang/rust.vim'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Maybe
  Plug 'janko-m/vim-test'

  " Trial
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'tmhedberg/SimpylFold'
  Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
  
  " Contextual
  "Plug 'cespare/vim-toml'
  Plug 'chr4/nginx.vim'
  "Plug 'hashivim/vim-terraform'

  call plug#end()
endif

" Set up Go support
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on

" Set up tabs and indenting
set ai
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
filetype plugin indent on

" block help on F1
nnoremap <F1> :echo "something useful"<CR>

" netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15

imap <C-[> <Esc>
imap jj <Esc>

" Searching and navigating
set wildignore+=*.pyc
nmap ; :Buffers<CR>
nmap <BS> :Files<CR>
nmap = :Rg<CR>

" Smartcase search
set ignorecase
set smartcase

" Rulers and markers
set nowrap   " do not wrap lines
set ruler    " show cursor position all the time
"set number   " show the line numbers
set number relativenumber " show line numbers relative to current position

" Syntax handling and checking
set t_Co=256
syntax enable
syntax on
au BufRead,BufNewFile *.md set filetype=markdown  " set .md files as markdown
au BufRead,BufNewFile Jenkinsfile set filetype=groovy


if has("nvim")
  set termguicolors
  let g:gruvbox_italic=1
  let g:gruvbox_contrast_dark="hard"
  colorscheme gruvbox
endif

set background=dark
set colorcolumn=120
highlight ColorColumn ctermbg=7



" Set up mapleader
let mapleader=","
map <Leader>t :Vexplore<CR>
map <Leader>s :w<CR>
map <Leader>x :bd<CR>
map <Leader>u :set hlsearch!<CR>


" copy and paste to system clipboard
noremap <Leader>y "+y
noremap <Leader>p "+p

" Set up vim-test
if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "dispatch"
endif

" run tests
" nearest
nmap <silent> <leader>n :TestNearest<CR>
" file
nmap <silent> <leader>N :TestFile<CR>
" suite
nmap <silent> <leader>a :TestSuite<CR>
" runs the last test
nmap <silent> <leader>m :TestLast<CR>
" go back to last test file
nmap <silent> <leader>M :TestVisit<CR>


" go to next tab
noremap <Leader>l :tabnext<CR>
" go to previous tab
noremap <Leader>k :tabprevious<CR>
" move tab right
noremap <Leader>L :execute 'silent! tabmove ' . (tabpagenr() + 1)<CR>
" move tab left
noremap <Leader>K :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>

tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" Useful key mappings
" <C-w>c close window
" <C-w>_ maximise window
" <C-w>r rotate windows
"
" Useful help
" :help index  - index of key mappings

" Diff
set diffopt+=vertical

" Fix broken backspace
set backspace=indent,eol,start

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1
