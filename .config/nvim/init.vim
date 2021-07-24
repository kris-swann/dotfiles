" PLUGINS
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'shaunsingh/nord.nvim'
  Plug 'navarasu/onedark.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-fugitive'
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/goyo.vim'
  Plug 'psliwka/vim-smoothie'
  Plug 'godlygeek/tabular'
  Plug 'easymotion/vim-easymotion'
  Plug 'ambv/black'
  Plug 'prettier/vim-prettier', { 'do': 'npm install -g prettier' }
  Plug 'francoiscabrol/ranger.vim'
  Plug 'rbgrouleff/bclose.vim' "Dep of ranger
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'  " Opt dep of lualine
  " TODO eval telescope as replacement
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " TODO evaluate replacement
  Plug 'Shougo/context_filetype.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  " TODO evaluate replacements
  Plug 'w0rp/ale'
call plug#end()


" BASIC CONFIG
filetype plugin indent on           " Turn on detection, plugin and indent
set cursorline                      " Highlight current line
set signcolumn=yes                  " Always show signcolumn
set colorcolumn=100
set hidden                          " Allow non-active buffers to be unsaved
set updatetime=100                  " Write swap file to disk after 100ms of no typing
set listchars=tab:▸\ ,eol:¬,trail:⋅ " Whitespace chars
set list                            " Show the whitespace characters
set undofile                        " Save undo history between sessions
set ignorecase smartcase            " Search case insensitive unless capital used
set shortmess=filnxtToOf
set completeopt-=preview            " No preview windows for insert mode completion
" What is saved with :mksession
set sessionoptions=curdir,winpos,resize,help,blank,winsize,folds,tabpages


" BUILT IN AUTOCOMPLETION STUFF
set omnifunc=syntaxcomplete#Complete
set path+=**  " Recursively search subdirs, allows tab-completion, and * for fuzzy search
set wildmode=longest:full,full  " Wildmenu autocompletes longest common substring then cycles through options
" Dirs to ignore in wildmenu
set wildignore+=*__pycache__*,*.pyc,*env/*,*.egg-info*


" COLORS
set termguicolors " Use gui instead of cterm colors in terminal
let g:onedark_style = 'warm'
colorscheme onedark
lua << EOF
  local c = require('onedark.colors')
  vim.cmd("highlight Folded gui=NONE guifg=" .. c.fg .. " guibg=" .. c.dark_cyan)
  vim.cmd("highlight RegLineNr guifg=" .. c.grey)
  vim.cmd("highlight ModifiedLineNr guifg=" .. c.grey .. " guibg=#3c3047")
EOF
" Change color of line number col when file is modified
augroup cursorlinecolor
  autocmd!
  autocmd BufModifiedSet * 
  \ if &modified | set winhighlight=LineNr:ModifiedLineNr, |
  \ else | set winhighlight=LineNr:RegLineNr, |
  \ endif
augroup END


" LINE NUMBERS
" Autotoggle between relative and absolute numbers (from jeffkreeftmeijer/vim-numbertoggle)
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter,TermOpen,TermClose *
  \ if &buftype == "terminal" | set nonu | set nornu |
  \ elseif mode() != "i" | set nu | set rnu |
  \ else | set nu | set nornu |
  \ endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * set nornu
augroup END


" INDENTATION
set expandtab  " Use softtabs
" Default indentation preferences
set softtabstop=2
set tabstop=2
set shiftwidth=2


" FOLDS
set foldmethod=manual
set foldcolumn=0
" Togle manual fold creation and deletion
nnoremap \ zD
vnoremap \ zf
function! CustomFoldText()
  let ismodified = exists('g:loaded_gitgutter') && gitgutter#fold#is_changed()
  let modifiedchar = ismodified ? ' ⊡' : '  '
  let numlines = v:foldend - v:foldstart + 1
  let righttext = modifiedchar . ' 祉' . numlines . ' lines'
  " Special chars screw up len(righttext), have to manually define
  let righttextlen = len(numlines . ' lines') + 6
  let line = getline(v:foldstart)
  let approxleftcols = 7
  let maxlen = min([winwidth(0) - approxleftcols, &colorcolumn])
  let maxfoldstrlen = maxlen - righttextlen
  if len(line) > maxfoldstrlen
    let line = line[0:(maxfoldstrlen - 4)] . '...'
  endif
  let fillcharcount = maxlen - len(line) - righttextlen
  return line . repeat(' ', fillcharcount) . righttext
endfunction
set foldtext=CustomFoldText()
" Use spaces instead of dots for remaining chars (Trailing space intentional)
set fillchars=fold:\ 


" BASIC MAPPINGS
let mapleader=","
" Same movement in wrappend lines
noremap j gj
noremap k gk
" Scrolling
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
" Easy copy-pasting to and from system clipboard
vnoremap <leader>y "+y
vnoremap <leader>d "+d
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>P "+P
" Easy exit out of terminal
tnoremap <esc> <C-\><C-n>
" Esc clears highlighting (after search)
map <esc> :noh<bar>lclose<bar>pclose<CR>
" Recalculate syntax highlighting
noremap <leader>s <Esc>:syntax sync fromstart<CR>


" BASIC COMMANDS
" Shortcut to neovim config file
command! Config :e ~/.config/nvim/init.vim   
" Shortcut to notes
command! Notes :e ~/Documents/Notes/index.md
" Remove trailing whitespace
command! StripTrailingWhitespace :call Preserve("%s/\\s\\+$//e")
" Run js-beautify on current file
command! JSBeautify :!js-beautify % -r
" Run shfmt on current file
command! Shfmt :!shfmt -i 2 -w -s %


" PLUGIN TREESITTER
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = {"haskell"}, -- causes issues on osx
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF


" PLUGIN HEXOKINASE
let g:Hexokinase_highlighters = ['virtual']
let g:Hexokinase_optInPatterns = ['full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names']


" PLUGIN DEOPLETE
let g:deoplete#enable_at_startup=1


" PLUGIN FZF
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit' }
map <leader>af :Files<CR>
map <leader>f :GitFiles<CR>
map <leader>g :Rg<CR>


" PLUGIN GITGUTTER
let g:gitgutter_enabled=1
let g:gitgutter_realtime=1


" PLUGIN LUALINE
" search for trailing whitespace: [ \t]\+$
" search for mixed indent
lua << EOF
function wordcount() return vim.fn.wordcount().words .. ' words' end
function statusline_progress() return '%P' end
function statusline_loc() return '%3l:%-2c %L' end
require'lualine'.setup {
  options = {
    theme = 'seoul256',
    icons_enabled = true,
    section_separators = {'', ''},
    component_separators = {'', ''},
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {
      -- TODO whitespace warnings
      -- TODO git merge conflict warnings
      {
        'diagnostics',
        sources = {'ale', 'nvim_lsp'},
        sections = {'error', 'warn', 'info', 'hint'},
      },
      'filetype',
      -- TODO Show word and line count of selction only when in visual modes (w/ clipboard or selction icon?)
      wordcount,
    },
    lualine_y = {statusline_progress},
    lualine_z = {statusline_loc},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {statusline_loc},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {'fugitive'}
}
EOF


" PLUGIN RANGER
let g:ranger_replace_netrw = 1
nnoremap <leader>e :Ranger<CR>


" PLUGIN ALE
let g:ale_linters = {
\ 'python': ['flake8', 'pylint'],
\ 'typescript': ['eslint', 'prettier', 'standard', 'tslint', 'typecheck'],
\ }
" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Get nicer messages from ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] [%linter%] %[code]% %s'
" Gutter icons
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:ale_sign_info = ' '
highlight link ALEErrorSign lualine_x_diagnostics_error_normal
highlight link ALEWarningSign lualine_x_diagnostics_warn_normal
highlight link ALEInfoSign lualine_x_diagnostics_info_normal
" Python linting options
let g:ale_python_flake8_change_directory = 'off'
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


" FILE SPECIFIC CONFIG
" Update bindings when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
