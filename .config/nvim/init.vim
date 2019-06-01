" SET BASIC VIM OPTIONS:
set number                          " Make line numbers visible
set relativenumber                  " Use relative line numbers
set colorcolumn=79                  " Show column at column 79
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
set softtabstop=2
set tabstop=2
set shiftwidth=2


" BASIC HELPER FUNCTIONS:
function! Preserve(command)
  " Execute a command without altering any state
  " Preparation save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction


" BASIC MAPPINGS:
let mapleader=","
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
" Recalculate syntax highlighting
noremap <leader>s <Esc>:syntax sync fromstart<CR>


" BASIC COMMANDS:
" Command for quick editing of config file
command! EditConfig :e ~/.config/nvim/init.vim
" Command for quick editing of notes
command! Notes :e ~/Documents/notes
" Command for gathering tags
command! MakeTags :Dispatch! ctags -R .
" Easily remove trailing whitespace with regex
command! StripTrailingWhitespace :call Preserve("%s/\\s\\+$//e")


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
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'Shougo/context_filetype.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'w0rp/ale'
  Plug 'airblade/vim-gitgutter'
  Plug 'vim-airline/vim-airline'
  Plug 'rbgrouleff/bclose.vim'
  Plug 'francoiscabrol/ranger.vim'  " Depends on bclose.vim
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'ambv/black'
  "Plug 'Valloric/MatchTagAlways'
call plug#end()


" BASIC PLUGIN CUSTOMIZATION:
cabbrev Gpush Git push
let g:deoplete#enable_at_startup=1
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
map <leader>af :Files<CR>
map <leader>f :GitFiles<CR>
map <leader>g :Rg<CR>
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

" Vue options
let g:vue_disable_pre_processors=1  " Speed up vim-vue syntax highlighting
" github.com/posva/vim-vue#vim-slows-down-when-using-this-plugin-how-can-i-fix-that
