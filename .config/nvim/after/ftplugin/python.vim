" Insert debugger breakpoints
nnoremap <leader>bb O__import__("ipdb").set_trace()<Esc>
nnoremap <leader>bp O__import__("pdb").set_trace()<Esc>

" TODO use seperate venv for isort and black, remove dependence on black plugin?

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
augroup blackfile
  autocmd!
  autocmd BufWritePost <buffer> :call ConditionalBlack()
augroup END
