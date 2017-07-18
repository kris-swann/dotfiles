" SET BASIC VIM OPTIONS:
set number                          " Make line numbers visible.
set relativenumber                  " Use relative line numbers.
set cursorline                      " Highlight the current line.
set hidden                          " Allow non-active buffers to be unsaved.
set updatetime=100                  " Make update faster.
set listchars=tab:▸\ ,eol:¬,trail:⋅ " Set the whitespace characters.
set list                            " Show the whitespace characters.
set undofile                        " Save undo history between sessions.
set mouse=a                         " Enable the use of the mouse.
colorscheme onedark                 " Set the default colorscheme.
" Customize what is saved with :mksession.
set sessionoptions=curdir,winpos,resize,help,blank,winsize,folds,tabpages
set completeopt-=preview            " No preview windows!


" INDENTATION:
filetype plugin indent on           " Turn on detection, plugin and indent.
set expandtab                       " Use softtabs.
" Default indentation preferences.
set softtabstop=4                   " Use 4 wide softtabs.
set tabstop=4                       " Have vim display tabs as 4 spaces.
set shiftwidth=4                    " Set the shift width to reflect tabspace.
" Filetype specific preferences.
autocmd Filetype css,html,htmldjango setlocal ts=2 sts=2 sw=2


" BASIC MAPPINGS AND COMMANDS:
let mapleader=","
" Use tabs to go through tabs.
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" Same movement in wrappend lines.
noremap j gj
noremap k gk
" Scroll the viewport 5 times faster.
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap <M-j> 5j
nnoremap <M-k> 5k
" Quick adjustment of window sizes.
nnoremap <C-w>, <C-w>10>
nnoremap <C-w>. <C-w>10<
nnoremap <C-w>- <C-w>10-
nnoremap <C-w>+ <C-w>10+
" Command for quick editing of config file.
command! EditConfig :e ~/.config/nvim/init.vim
" Command for quick editing of notes
command! Notes :e ~/Documents/notes
" Shortcut for opening file browser.
nnoremap <leader>e :e.<CR>
" Clearing highlighting (after search).
map <esc> :noh<bar>lclose<bar>pclose<CR>
" Shortcut for find command. (Using Denite plugin for now.)
"noremap <leader>f :find
" For use in python files, use isort to auto sort imports.
"autocmd FileType python command <buffer> Isort :!isort %


" TRAILING WHITESPACE:
function! StripTrailingWhitespaces()
    " Save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business.
    %s/\s\+$//e
    " Restore previous search history, and cursor position.
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespaces :call StripTrailingWhitespaces()


" TAGS:
" Command for gathering tags.
command! MakeTags :Dispatch! ctags -R .


" FOLDS:
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

set foldlevel=99                    " Set folds to be open on start.
set foldcolumn=1                    " Show folds in the column.

autocmd Filetype vim setlocal foldlevel=0 foldmethod=expr foldexpr=VimFolds()


" BUILT IN AUTOCOMPLETION STUFF:
set omnifunc=syntaxcomplete#Complete
set path+=**                        " Recursively search subdirs for files,
                                    " allows for tab-completion for file
                                    " related tasks. Use * to make it fuzzy.
set wildmode=longest:full,full      " Wildmenu autocompletes longest common substring
                                    " and then cycles through options.
" Directories to ignore in wildmenu.
set wildignore+=*__pycache__*,*.pyc,*env/*,*.egg-info*


" PLUGIN DECLARATIONS:
set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.config/nvim/dein')
    call dein#begin('~/.config/nvim/dein')

    call dein#add('~/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-dispatch')
    call dein#add('tpop/vim-repeat')
    call dein#add('tpope/vim-fugitive')
    call dein#add('michaeljsmith/vim-indent-object')
    call dein#add('sheerun/vim-polyglot')
    call dein#add('haya14busa/incsearch.vim')
    call dein#add('myusuf3/numbers.vim')
    call dein#add('godlygeek/tabular')
    call dein#add('easymotion/vim-easymotion')
    call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
    call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('zchee/deoplete-jedi')
    call dein#add('w0rp/ale')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('vim-airline/vim-airline')
    call dein#add('majutsushi/tagbar')
    call dein#add('junegunn/goyo.vim')
    call dein#add('scrooloose/nerdtree.git')
    call dein#add('python-mode/python-mode')
    call dein#add('davidhalter/jedi-vim')
    "call dein#add('luochen1990/rainbow')
    "call dein#add('Valloric/MatchTagAlways')

    call dein#end()
    call dein#save_state()
endif


" BASIC PLUGIN CUSTOMIZATION:
cabbrev Gpush Git push
let g:deoplete#enable_at_startup=1
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
map <leader>f :Files<CR>
let g:gitgutter_enabled=1
let g:gitgutter_realtime=1
let g:airline_powerline_fonts = 1
let g:NERDTreeIgnore=['.*__pycache__.*','.*\.pyc','.*\.egg-info.*']

" Get nicer messages from ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Python linting options
let g:ale_python_pylint_options = '--rcfile toolchain/.pylintrc'
let g:ale_python_flake8_options = '--config=toolchain/.flake8'

" Improved incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Don't use jedi-vim's completions, only using it for the static analysis
let g:jedi#completions_enabled = 0
" Only using pymode for folding and motions (Have to disable everything
" manually since pymode assumes it's oh-so-fantastic).
let g:pymode = 1
let g:pymode_options_max_line_length = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_python='python3'
let g:pymode_indent = 0
let g:pymode_folding = 1
let g:pymode_motion = 0
let g:pymode_doc = 0
let g:pymode_virtualenv = 0
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_syntax = 0
" Pymode custom motions, since cutomability is apparently the anti-christ
autocmd FileType python nnoremap <buffer> ]]  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', '')<CR>
autocmd FileType python nnoremap <buffer> [[  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', 'b')<CR>
autocmd FileType python nnoremap <buffer> ]c  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', '')<CR>
autocmd FileType python nnoremap <buffer> [c  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', 'b')<CR>
autocmd FileType python nnoremap <buffer> ]m  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', '')<CR>
autocmd FileType python nnoremap <buffer> [m  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', 'b')<CR>
autocmd FileType python onoremap <buffer> ]]  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', '')<CR>
autocmd FileType python onoremap <buffer> [[  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', 'b')<CR>
autocmd FileType python onoremap <buffer> ]c  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', '')<CR>
autocmd FileType python onoremap <buffer> [c  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', 'b')<CR>
autocmd FileType python onoremap <buffer> ]m  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', '')<CR>
autocmd FileType python onoremap <buffer> [m  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', 'b')<CR>
autocmd FileType python vnoremap <buffer> ]]  :call pymode#motion#vmove('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', '')<CR>
autocmd FileType python vnoremap <buffer> [[  :call pymode#motion#vmove('<Bslash>v^(class<bar><Bslash>s*def)<Bslash>s', 'b')<CR>
autocmd FileType python vnoremap <buffer> ]m  :call pymode#motion#vmove('^<Bslash>s*def<Bslash>s', '')<CR>
autocmd FileType python vnoremap <buffer> [m  :call pymode#motion#vmove('^<Bslash>s*def<Bslash>s', 'b')<CR>
autocmd FileType python onoremap <buffer> c   :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
autocmd FileType python onoremap <buffer> ac  :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
autocmd FileType python onoremap <buffer> ic  :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 1)<CR>
autocmd FileType python vnoremap <buffer> ac  :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
autocmd FileType python vnoremap <buffer> ic  :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 1)<CR>
autocmd FileType python onoremap <buffer> m   :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
autocmd FileType python onoremap <buffer> am  :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
autocmd FileType python onoremap <buffer> im  :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 1)<CR>
autocmd FileType python vnoremap <buffer> am  :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
autocmd FileType python vnoremap <buffer> im  :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 1)<CR>


" " RAINBOW PARENTHESES BEAUTIFULNESS:
" let g:rainbow_active = 1
" let g:rainbow_conf = {
" \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
" \   'ctermfgs': ['darkblue', 'darkgreen', 'darkyellow', '133'],
" \   'operators': '_,_',
" \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
" \   'separately': {
" \       '*': {},
" \       'tex': {
" \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
" \       },
" \       'lisp': {
" \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
" \       },
" \       'vim': {
" \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
" \       },
" \       'css': 0,
" \      'html': {
" \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
" \		},
" \   }
" \}
