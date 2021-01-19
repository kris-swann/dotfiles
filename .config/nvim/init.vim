" BASIC CONFIG
colorscheme onedark
filetype plugin indent on           " Turn on detection, plugin and indent
set number                          " Visible line numbers
set relativenumber
set colorcolumn=110
set cursorline                      " Highlight current line
set hidden                          " Allow non-active buffers to be unsaved
set updatetime=100                  " Write swap file to disk after 100ms of no typing
set listchars=tab:▸\ ,eol:¬,trail:⋅ " Whitespace chars
set list                            " Show the whitespace characters
set undofile                        " Save undo history between sessions
set ignorecase smartcase            " Search case insensitive unless capital used
set completeopt-=preview            " No preview windows for insert mode completion
" What is saved with :mksession
set sessionoptions=curdir,winpos,resize,help,blank,winsize,folds,tabpages


" INDENTATION
set expandtab  " Use softtabs
" Default indentation preferences
set softtabstop=2
set tabstop=2
set shiftwidth=2


" FOLDS
set foldlevel=99        " Set folds to be open on start
set foldcolumn=1        " Show folds in the column
set foldminlines=4      " Downt allow annoying tiny folds


" BUILT IN AUTOCOMPLETION STUFF
set omnifunc=syntaxcomplete#Complete
set path+=**  " Recursively search subdirs, allows tab-completion, and * for fuzzy search
set wildmode=longest:full,full  " Wildmenu autocompletes longest common substring then cycles through options
" Dirs to ignore in wildmenu
set wildignore+=*__pycache__*,*.pyc,*env/*,*.egg-info*


" BASIC MAPPINGS
let mapleader=","
" Same movement in wrappend lines
noremap j gj
noremap k gk
" Ergonomic scrolling
" TODO
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
" Esc clears highlighting (after search)
map <esc> :noh<bar>lclose<bar>pclose<CR>
" Recalculate syntax highlighting
noremap <leader>s <Esc>:syntax sync fromstart<CR>


" BASIC COMMANDS
" Shortcut to neovim config file
command! EditConfig :e ~/.config/nvim/init.vim
" Shortcut to notes
command! Notes :e ~/Documents/Notes/index.md
" Remove trailing whitespace
command! StripTrailingWhitespace :call Preserve("%s/\\s\\+$//e")
" Run js-beautify on current file
command! JSBeautify :!js-beautify % -r
" Run shfmt on current file
command! Shfmt :!shfmt -i 2 -w -s %


" PLUGINS
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
  Plug 'junegunn/goyo.vim'
  Plug 'Shougo/context_filetype.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'w0rp/ale'
  Plug 'airblade/vim-gitgutter'
  Plug 'vim-airline/vim-airline'
  Plug 'rbgrouleff/bclose.vim'
  Plug 'francoiscabrol/ranger.vim'  " Depends on bclose.vim
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'ambv/black'
  Plug 'prettier/vim-prettier', { 'do': 'npm install -g prettier' }
call plug#end()


" PLUGIN DEOPLETE CONFIG
let g:deoplete#enable_at_startup=1


" PLUGIN FZF CONFIG
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit' }
map <leader>af :Files<CR>
map <leader>f :GitFiles<CR>
map <leader>g :Rg<CR>


" PLUGIN GIT GUTTER CONFIG
let g:gitgutter_enabled=1
let g:gitgutter_realtime=1


" PLUGIN AIRLINE CONFIG
let g:airline_powerline_fonts = 1


" PLUGIN RANGER CONFIG
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
nnoremap <leader>e :Ranger<CR>


" PLUGIN INCSEARCH CONFIG
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" PLUGIN ALE CONFIG
let g:ale_linters = {
\ 'python': ['pyflakes', 'pylint', 'pylama'],
\ }
" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Get nicer messages from ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] [%linter%] %s'
" Python linting options
let g:ale_python_pylint_options = '--rcfile toolchain/.pylintrc'
let g:ale_python_flake8_options = '--config=toolchain/.flake8'
let g:ale_python_pylama_options = '--options ~/toolchain/pylama.ini'
" Cpp linting options
let g:ale_cpp_clangtidy_options = '-Wall -std=c++11 -x c++'
let g:ale_cpp_clangcheck_options = '-- -Wall -std=c++11 -x c++'


" HELPER FUNCTIONS
function! Preserve(command)
  " Execute a command without altering any state
  " Save last search, and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Run the command
  execute a:command
  " Restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction


" FILE SPECIFIC OPERATIONS
" Update bindings when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
