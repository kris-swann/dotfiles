" BASIC CONFIG
filetype plugin indent on           " Turn on detection, plugin and indent
lua << EOF
-- TODO investigate sessions (via :mksession)
-- TODO add spell files to version control

vim.g.mapleader = ','      -- set leader as early as possible
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.signcolumn = 'yes'   -- always show signcolumn
vim.o.undofile = true      -- persist undos between sessions
vim.o.hidden = true        -- allow hidden buffers to be unsaved
vim.o.termguicolors = true -- use gui instead of cterm highlight colors

vim.o.wildmode = 'longest:full,full'  -- command mode completions: longest common substr then cycle options
vim.o.omnifunc = 'syntaxcomplete#Complete'  -- basic omnifunc for <C-x><C-o> completions

-- default indent prefs
vim.o.expandtab = true  -- softtabs
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.list = true
vim.opt.listchars = {
  tab =      '» ',
  eol =      '¬',
  trail =    '⋅',
  precedes = '←',
  extends =  '→',
}
vim.o.showbreak = '↪ '
vim.opt.fillchars = {
  vert =      '│',
  fold =      ' ',
  foldclose = '─',
  foldopen =  '┬',
  foldsep =   '│',
}

EOF

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

" FOLDS
set foldmethod=manual
" Togle manual fold creation and deletion
nnoremap \ zD
vnoremap \ zf
set foldtext=CustomFoldText()
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


" PLUGINS
" TODO switch over to lua plugin manager
" TODO investigate .editorconfig plugin
" TODO move up in file?
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'nvim-lua/plenary.nvim'
  " TODO write own colorscheme
  Plug 'shaunsingh/nord.nvim'
  Plug 'navarasu/onedark.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-repeat'
  " TODO checkout vimagit
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
  " TODO write own statusline
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
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



" COLORS
let g:onedark_style = 'warm'
colorscheme onedark
lua << EOF
local c = require'onedark.colors'
vim.cmd('highlight Folded gui=NONE guifg=' .. c.fg .. ' guibg=' .. c.dark_cyan)
vim.cmd('highlight ModifiedLineNr guifg=' .. c.grey .. ' guibg=#3c3047')

function _G.highlight_modified_buffers()
  local winids = vim.api.nvim_list_wins()
  for _, winid in ipairs(winids) do
    local bufnr = vim.fn.winbufnr(winid)
    if (vim.bo[bufnr].modified) then
      vim.wo[winid].winhighlight = 'LineNr:ModifiedLineNr'
    else
      vim.wo[winid].winhighlight = ''
    end
  end
end
EOF
augroup highlight_modified_buffers
  autocmd!
  autocmd BufModifiedSet,BufWinEnter * :lua _G.highlight_modified_buffers()
augroup END

lua << EOF
-- STATUSLINE
statusline = require'statusline'
_G.make_statusline = statusline.make_statusline
vim.o.statusline = '%!v:lua.make_statusline()'
EOF


" BASIC MAPPINGS, COMMANDS, ABBREVS
" Prefer virtual replace over normal replace
nnoremap R gR
" Disable Ex Mode
noremap Q <Nop>
noremap gQ <Nop>
" Same movement in wrappend lines
noremap j gj
noremap k gk
" Scrolling
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap zl zL
nnoremap zh zH
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
" Shortcut to neovim config file
command! Config :e ~/.config/nvim/init.vim   
" Shortcut to notes
command! Notes :e ~/Documents/Notes/index.md
" TODO switch this over to lua and get rid of Preserve function
" Remove trailing whitespace
command! StripTrailingWhitespace :call Preserve("%s/\\s\\+$//e")
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
" Run js-beautify on current file
command! JSBeautify :!js-beautify % -r
" Run shfmt on current file
command! Shfmt :!shfmt -i 2 -w -s %
" Shortcut to easily inspect lua stuff
cnoreabbrev L lua print(vim.inspect(


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
lua << EOF
--[[
function statusline_progress() return '%p%%' end
function statusline_loc() return '%l:%-2c %L☰' end
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
      {
        'diagnostics',
        sources = {'ale', 'nvim_lsp'},
        sections = {'error', 'warn', 'info', 'hint'},
      },
      'filetype',
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
]]
EOF


" PLUGIN RANGER
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
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


" FILE SPECIFIC CONFIG
" Update bindings when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
