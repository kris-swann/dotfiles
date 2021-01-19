" TODO
function! GetPythonModulePath(stringScope)
  " Call external script passing along current file and line number
  return system("python_module_path " . expand('%') . ' ' . line('.') . ' ' . a:stringScope)
endfunction
" Copy results to clipboard (the '+' register)
nnoremap ymf :let @+=GetPythonModulePath("file")<CR>
nnoremap ymc :let @+=GetPythonModulePath("class")<CR>
nnoremap ymm :let @+=GetPythonModulePath("method")<CR>

" Order imports with isort
command! Isort :!isort %

" Easy toggle for Black-ing files
function! ConditionalBlack()
  " Enabled if variable is unset or set to anything other than off
  let enabled = !exists("b:autoblack") || b:autoblack != "off"
  if (exists(":Black") && enabled)
    execute "Black"
  endif
endfunction
command! Blackon :let b:autoblack="on"
command! Blackoff :let b:autoblack="off"
autocmd BufWritePost <buffer> :call ConditionalBlack()

" Insert debugger breakpoints
nnoremap <leader>bb O__import__("ipdb").set_trace()<Esc>
nnoremap <leader>bp O__import__("pdb").set_trace()<Esc>
