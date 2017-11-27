" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8
set fileencoding=utf-8
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" vim-plug https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'flazz/vim-colorschemes'
Plug 'gcmt/taboo.vim'
Plug 'hashivim/vim-terraform'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'python-mode/python-mode'
Plug 'tpope/vim-dispatch'
call plug#end()

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

"  - Filetype specific settings
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType go setlocal noexpandtab
autocmd FileType java setlocal shiftwidth=4 tabstop=4

" netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15


" Ack
imap <C-_> <ESC>:Ack 
nmap <C-_> :Ack 

if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

" Searching and navigating
set wildignore+=*.pyc
nmap ; :Buffers<CR>
nmap <C-?> :Files<CR>
nmap <A-?> :Files<CR>

" Smartcase search
set ignorecase
set smartcase

" Rulers and markers
set nowrap   " do not wrap lines
set ruler    " show cursor position all the time
"set number   " show the line numbers
set relativenumber " show line numbers relative to current position

" Syntax handling and checking
set t_Co=256
syntax enable
syntax on
au BufRead,BufNewFile *.md set filetype=markdown  " set .md files as markdown
au BufRead,BufNewFile Jenkinsfile set filetype=groovy
if has('gui_running')
  colorscheme solarized
else
  colorscheme vividchalk
endif
set background=dark
let g:syntastic_python_checkers = ["flake8"]
set colorcolumn=80
highlight ColorColumn ctermbg=7

" Set up vim-test
let test#strategy = "dispatch"
let test#python#runner = 'pytest'
let test#python#pytest#options = '-s'

" Set up mapleader
let mapleader=","
map <Leader>t :Vexplore<CR>
let g:pep8_map='<leader>8'
map <Leader>s :w<CR>

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

" go to definition
nmap <silent> <leader>g :call pymode#rope#goto_definition()<CR>
" show docstring
nmap <silent> <leader>d :call pymode#rope#show_doc()<CR>


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

" python-mode
let g:pymode_python = 'python3'
set foldlevel=20
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_rope_complete_on_dot = 0
set completeopt=menu
let g:pymode_rope_show_doc_bind = 'K'

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" Project specific .vimrc
set exrc  " allow project specific .vimrc
set secure  " disable unsafe commands
