" Ex: Run Black before writing the current buffer
" autocmd BufWritePre <buffer> :Black

function! GetPythonModuleName(stringScope)
  " Call external script passing along current file and line number
  return system("python_module_name " . expand('%') . ' ' . line('.') . ' ' . a:stringScope)
endfunction

" Copy results to clipboard (the '+' register)
nnoremap <buffer> ymf :let @+=GetPythonModuleName("file")<CR>
nnoremap <buffer> ymc :let @+=GetPythonModuleName("class")<CR>
nnoremap <buffer> ymm :let @+=GetPythonModuleName("method")<CR>
