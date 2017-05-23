" SET BASIC VIM OPTIONS:
set nu                              " Make line numbers visible.
set relativenumber                  " Use relative line numbers.
set cursorline                      " Highlight the current line.
set hidden                          " Allow non-active buffers to be unsaved.
set updatetime=100                  " Make update faster.
set listchars=tab:▸\ ,eol:¬,trail:⋅ " Set the whitespace characters.
set list                            " Show the whitespace characters.
set undofile                        " Save undo history between sessions.
set mouse=a                         " Enable the use of the mouse.
colorscheme onedark                 " Set the default colorscheme.


" INDENTATION:
filetype plugin indent on           " Turn on detection, plugin and indent.
set expandtab                       " Use softtabs.
" Default indentation preferences.
set softtabstop=4                   " Use 4 wide softtabs.
set tabstop=4                       " Have vim display tabs as 4 spaces.
set shiftwidth=4                    " Set the shift width to reflect tabspace.
" Filetype specific preferences.
autocmd Filetype html,htmldjango setlocal ts=2 sts=2 sw=2


" BASIC MAPPINGS AND COMMANDS:
" Same movement in wrappend lines.
noremap j gj
noremap k gk
" Scroll the viewport 3 times faster.
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap <M-j> 5j
nnoremap <M-k> 5k
" Command for quick editing of config file.
command! EditConfig e ~/.config/nvim/init.vim
let mapleader=","
" Shortcut for opening file browser.
nnoremap <leader>e :e.<CR>
" Map :E to open deafult filebrowser (not always netrw).
command! E e.
" Clearing highlighting (after search).
map <esc> :noh<CR>
" Shortcut for find command. (Using Denite plugin for now.)
"noremap <leader>f :find


" TAGS:
" Command for gathering tags.
command! Tags ! ctags -R .


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

autocmd Filetype vim setlocal foldlevel=0
autocmd Filetype vim setlocal foldmethod=expr
autocmd Filetype vim setlocal foldexpr=VimFolds()


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
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('vim-airline/vim-airline')
  call dein#add('scrooloose/nerdtree.git')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/denite.nvim')
  call dein#add('zchee/deoplete-jedi')
  call dein#add('python-mode/python-mode')

  call dein#end()
  call dein#save_state()
endif


" BASIC PLUGIN CUSTOMIZATION:
let g:deoplete#enable_at_startup=1
let g:gitgutter_enabled=1
let g:gitgutter_realtime=1
let g:airline_powerline_fonts = 1
let g:NERDTreeIgnore=['.*__pycache__.*','.*\.pyc','.*\.egg-info.*']
let g:pymode_python='python3'
let g:pymode_breakpoint_bind = '<leader>B'  " Remap conflicting default mapping.


" DENITE CUSTOMIZATION:
" Denite mappings and commands.
nnoremap <leader>b :Denite buffer -mode=normal<CR>
command! LS Denite buffer -mode=normal
nnoremap <leader>f :Denite file_rec<CR>
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
" Make file_rec (<leader>f) ignore certain files and paths.
call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.*', 'env/', '*.pyc', '*__pycache__*', '*.egg-info/'])
" onedark.vim override: Make highlighting look nice in denite.
if (has("autocmd") && !has("gui"))
  let s:yellow = { "gui": "#E5C07B", "cterm": "180", "cterm16": "3" }
  let s:comment_grey = { "gui": "#5C6370", "cterm": "59", "cterm16": "15" }
  autocmd ColorScheme * call onedark#set_highlight("deniteMatchedChar",
    \ { "fg": s:yellow, "bg": s:comment_grey })
end
