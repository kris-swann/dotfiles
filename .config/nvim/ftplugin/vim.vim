function! VimFolds()
    let thisline = getline(v:lnum)
    let nextline = getline(v:lnum+1)
    " Set foldlevel 1 on comments that end with ':'.
    if match(thisline, '^".*:$') >= 0
        return ">1"
    " End fold when two blank lines are encountered.
    elseif match(thisline, '^$') >= 0 && match(nextline, '^$') >=0
        return "0"
    else
        return "="
    endif
endfunction

setlocal foldlevel=0        " CLose folds by default
setlocal foldminlines=1     " Allow tiny folds in vim config
" Custom folding syntax
setlocal foldmethod=expr foldexpr=VimFolds()
