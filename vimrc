execute pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'benmills/vimux'
Plugin 'derekwyatt/vim-scala'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'janko-m/vim-test'
Plugin 'mileszs/ack.vim'
Plugin 'othree/html5.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
Plugin 'pearofducks/ansible-vim'
Plugin 'fatih/vim-go'
call vundle#end()
filetype plugin indent on

" Set up Go support
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" Set up tabs and indenting
set ai
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
filetype plugin indent on

"  - Filetype specific settings
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType go setlocal noexpandtab
autocmd FileType java setlocal shiftwidth=4 tabstop=4

" NERDTree

let NERDTreeShowHidden=1

" Ack
imap <C-a> <ESC>:Ack
nmap <C-a> :Ack

" Ctrlp
let g:ctrlp_user_command = 'find %s -type f | grep -v "/node_modules/" | grep -v "\.pyc$" | grep -v "\.git/"'

" Smartcase search
set ignorecase
set smartcase

" Rulers and markers
set nowrap   " do not wrap lines
set ruler    " show cursor position all the time
"set number   " show the line numbers
set relativenumber " show line numbers relative to current position

" Syntax handling
set t_Co=256
syntax on
au BufRead,BufNewFile *.md set filetype=markdown  " set .md files as markdown
colorscheme solarized
set background=dark

" Set up vim-test
let test#strategy = "dispatch"
let test#python#pytest#options = '-s'

let g:syntastic_python_checkers = ["pep8"]
set colorcolumn=120
highlight ColorColumn ctermbg=7
" Set up mapleader
let mapleader=","
map <Leader>t :NERDTree<CR>
let g:pep8_map='<leader>8'
map <Leader>s :w<CR>

" Searching and navigating
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*.pyc

" Useful key mappings
" <C-w>c close window
" <C-w>_ maximise window
" <C-w>r rotate windows
"
" Useful help
" :help index  - index of key mappings

set diffopt+=vertical
