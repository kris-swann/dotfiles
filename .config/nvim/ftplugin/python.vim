function! GetPythonModulePath(stringScope)
  " Call external script passing along current file and line number
  return system("python_module_path " . expand('%') . ' ' . line('.') . ' ' . a:stringScope)
endfunction

" Copy results to clipboard (the '+' register)
nnoremap <buffer> ymf :let @+=GetPythonModulePath("file")<CR>
nnoremap <buffer> ymc :let @+=GetPythonModulePath("class")<CR>
nnoremap <buffer> ymm :let @+=GetPythonModulePath("method")<CR>

" Easy toggle for Black-ing files
function! ConditionalBlack()
  " enabled if variable is unset or set to anything other than off
  let enabled = !exists("b:autoblack") || b:autoblack != "off"
  if (exists(":Black") && enabled)
    execute "Black"
  endif
endfunction
command! Blackon :let b:autoblack="on"
command! Blackoff :let b:autoblack="off"
autocmd BufWritePost <buffer> :call ConditionalBlack()

nnoremap <leader>bb O__import__("ipdb").set_trace()<Esc>
nnoremap <leader>bp O__import__("pdb").set_trace()<Esc>
