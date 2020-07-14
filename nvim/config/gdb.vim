let g:nvimgdb_disable_start_keymaps = 1

function! CargoPackageSrc()
  return substitute(expand('%:p'), "/src/.*", "/src/", "")
endfunction

function! CargoTestBinary()

  let l:command = "cargo test --no-run --message-format=json 2>/dev/null | " .
    \ "jq -r 'select(" .
    \   "(.profile.test == true) and (.target.src_path | startswith(\"" . CargoPackageSrc() . "\"))" .
    \  ") | .filenames[]' | " .
    \ "head -n 1 | " .
    \ "tr -d '\n'"

  return system(l:command)

endfunction

function! CargoDebugNearest()
  let l:full_path = expand('%')

  if test#test_file(l:full_path)
    let l:position = {}
    let l:position['file'] = l:full_path
    let l:position['line'] = line('.')
    let l:position['col'] = col('.')
  else
    return ':echo "Not near any tests"'
  endif

  " Fully qualified test function name (minus the program name)
  let l:build_position = test#rust#cargotest#build_position('nearest', l:position)[0][1:-2]

  if l:build_position =~# '::$'
    return ':echo "In a file that may contain tests but not in a test"'
  endif

  if l:build_position =~# '^src::'
    let l:build_position = substitute(l:build_position, "^src::", "", "")
  elseif l:build_position =~# '^tests::integration_test::'
    let l:build_position = substitute(l:build_position, "^tests::integration_test::", "", "")
  endif

  " Full path to the test binary we need to use
  let l:test_binary = CargoTestBinary()
  " Remove the hash from the end of the binary name
  let l:program_name = join(split(split(l:test_binary, "/")[-1], '-')[0:-2], '-')

  if exists('g:test#project_root')
    execute 'cd' g:test#project_root
  endif

  return ':GdbStart gdb ' .
    \ '-ex "tb ' . l:program_name . '::' . l:build_position . '" ' .
    \ '-ex "run" ' .
    \ '--args ' .
    \ l:test_binary . ' ' . l:build_position

endfunction

function! PytestDebugNearest()
  " TODO: extract to function
  let l:full_path = expand('%')

  if test#test_file(l:full_path)
    let l:position = {}
    let l:position['file'] = l:full_path
    let l:position['line'] = line('.')
    let l:position['col'] = col('.')
  else
    return ':echo "Not near any tests"'
  endif

  return ':GdbStartPDB pytest --trace ' . test#python#pytest#build_position('nearest', l:position)[0]

endfunction

" Debug these with echof

nmap <Leader>dd :GdbStart gdb ./target/debug/
nmap <Leader>dD :execute(CargoDebugNearest())<CR>
nmap <Leader>dp :GdbStartPDB python %
nmap <Leader>dP :execute(PytestDebugNearest())<CR>
nmap <Leader>db :GdbBreakpointToggle<CR>
nmap <Leader>dC :GdbBreakpointClearAll<CR>
nmap <Leader>dc :GdbContinue<CR>
nmap <Leader>dn :GdbNext<CR>
nmap <Leader>ds :GdbStep<CR>
nmap <Leader>df :GdbFinish<CR>

nmap <M-n> :GdbNext<CR>
nmap <M-s> :GdbStep<CR>
nmap <M-c> :GdbContinue<CR>
