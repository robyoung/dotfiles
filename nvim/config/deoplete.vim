set hidden
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ 'go': ['go-langserver'],
    \ 'typescript': ['docker', 'run', '-i', 'typescript-language-server'],
    \ }

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_selectionUI = "fzf"
let g:LanguageClient_loggingFile = "/tmp/LanguageClient.log"
let g:LanguageClient_serverStderr = "/tmp/LanguageServer.log"
let g:LanguageClient_loggingLevel = "DEBUG"

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Allow tab completion from deoplete
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Go to definition
nmap <Leader>g :call LanguageClient#textDocument_definition()<CR>
nmap <Leader>f :call LanguageClient#textDocument_formatting()<CR>
nmap <Leader>r :call LanguageClient#textDocument_references()<CR>
nmap <Leader>R :call LanguageClient#textDocument_rename()<CR>
" Show hover info
nmap <Leader>h :call LanguageClient#textDocument_hover()<CR>

