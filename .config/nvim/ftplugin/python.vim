" Ex: Run Black before writing the current buffer
" autocmd BufWritePre <buffer> :Black

function! GetPythonModulePath(stringScope)
  " Call external script passing along current file and line number
  return system("python_module_path " . expand('%') . ' ' . line('.') . ' ' . a:stringScope)
endfunction

" Copy results to clipboard (the '+' register)
nnoremap <buffer> ymf :let @+=GetPythonModulePath("file")<CR>
nnoremap <buffer> ymc :let @+=GetPythonModulePath("class")<CR>
nnoremap <buffer> ymm :let @+=GetPythonModulePath("method")<CR>
