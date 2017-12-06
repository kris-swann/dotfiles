" SET BASIC VIM OPTIONS:
set number                          " Make line numbers visible
set relativenumber                  " Use relative line numbers
set cursorline                      " Highlight the current line
set hidden                          " Allow non-active buffers to be unsaved
set updatetime=100                  " Make update faster
set listchars=tab:▸\ ,eol:¬,trail:⋅ " Set the whitespace characters
set list                            " Show the whitespace characters
set undofile                        " Save undo history between sessions
set mouse=a                         " Enable the use of the mouse
set ignorecase smartcase            " Search case insensitive unless capital used
colorscheme onedark                 " Set the default colorscheme
" Customize what is saved with :mksession
set sessionoptions=curdir,winpos,resize,help,blank,winsize,folds,tabpages
set completeopt-=preview            " No preview windows!


" INDENTATION:
filetype plugin indent on           " Turn on detection, plugin and indent
set expandtab                       " Use softtabs
" Default indentation preferences
set softtabstop=4                   " Use 4 wide softtabs
set tabstop=4                       " Have vim display tabs as 4 spaces
set shiftwidth=4                    " Set the shift width to reflect tabspace


" BASIC MAPPINGS:
let mapleader=","
" Use tabs to go through tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" Same movement in wrappend lines
noremap j gj
noremap k gk
" Scroll the viewport 5 times faster
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap <M-j> 5j
nnoremap <M-k> 5k
" Easy copy-pasting to and from system clipboard
vnoremap <leader>y "+y
vnoremap <leader>d "+d
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P
" Clearing highlighting (after search)
map <esc> :noh<bar>lclose<bar>pclose<CR>
" Easy exit out of terminal
tnoremap <esc> <C-\><C-n>


" BASIC COMMANDS:
" Command for quick editing of config file
command! EditConfig :e ~/.config/nvim/init.vim
" Command for quick editing of notes
command! Notes :e ~/Documents/notes
" Command for gathering tags
command! MakeTags :Dispatch! ctags -R .
" Easily remove trailing whitespace with regex
command! StripTrailingWhitespace :%s/\s\+$//e


" FOLDS:
set foldlevel=99        " Set folds to be open on start
set foldcolumn=1        " Show folds in the column
set foldminlines=4      " Downt allow annoying tiny folds


" BUILT IN AUTOCOMPLETION STUFF:
set omnifunc=syntaxcomplete#Complete
set path+=**                        " Recursively search subdirs for files,
                                    " allows for tab-completion for file
                                    " related tasks. Use * to make it fuzzy
set wildmode=longest:full,full      " Wildmenu autocompletes longest common substring
                                    " and then cycles through options
" Directories to ignore in wildmenu
set wildignore+=*__pycache__*,*.pyc,*env/*,*.egg-info*


" PLUGIN DECLARATIONS:
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-fugitive'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'sheerun/vim-polyglot'
    Plug 'haya14busa/incsearch.vim'
    Plug 'myusuf3/numbers.vim'
    Plug 'godlygeek/tabular'
    Plug 'easymotion/vim-easymotion'
    Plug 'junegunn/fzf', { 'build': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'Shougo/deoplete.nvim'
    Plug 'zchee/deoplete-jedi'
    Plug 'w0rp/ale'
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-airline/vim-airline'
    Plug 'majutsushi/tagbar'
    Plug 'junegunn/goyo.vim'
    Plug 'rbgrouleff/bclose.vim'
    Plug 'francoiscabrol/ranger.vim'  " Depends on bclose.vim
    Plug 'python-mode/python-mode', { 'for': 'python' }
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'iamcco/markdown-preview.vim'
    Plug 'iamcco/mathjax-support-for-mkdp'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'vim-pandoc/vim-pandoc'
    "Plug 'luochen1990/rainbow'
    "Plug 'Valloric/MatchTagAlways'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
call plug#end()


" BASIC PLUGIN CUSTOMIZATION:
let g:mkdp_path_to_chrome = "firefox"
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
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
nnoremap <leader>e :Ranger<CR>

" Get nicer messages from ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Python linting options
let g:ale_python_pylint_options = '--rcfile toolchain/.pylintrc'
let g:ale_python_flake8_options = '--config=toolchain/.flake8'
" Cpp linting options
let g:ale_cpp_clangtidy_options = '-Wall -std=c++11 -x c++'
let g:ale_cpp_clangcheck_options = '-- -Wall -std=c++11 -x c++'

" Improved incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Don't use jedi-vim's completions, only using it for the static analysis
let g:jedi#completions_enabled = 0
" Only using pymode for folding and motions (Have to disable everything
" manually since pymode assumes it's oh-so-fantastic)
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
