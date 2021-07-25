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
local c = require('onedark.colors')
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


" STATUSLINE
lua << EOF
local devicons = require'nvim-web-devicons'
local Job = require'plenary.job'

local mode_map = {
  ['n']    = { key = 'NORMAL',    display = 'N' },
  ['no']   = { key = 'O-PENDING', display = 'O-PENDING' },
  ['nov']  = { key = 'O-PENDING', display = 'O-PENDING' },
  ['noV']  = { key = 'O-PENDING', display = 'O-PENDING' },
  ['no'] = { key = 'O-PENDING', display = 'O-PENDING' },
  ['niI']  = { key = 'NORMAL',    display = 'N' },
  ['niR']  = { key = 'NORMAL',    display = 'N' },
  ['niV']  = { key = 'NORMAL',    display = 'N' },
  ['v']    = { key = 'VISUAL',    display = 'V' },
  ['V']    = { key = 'VISUAL',    display = 'V-LINE' },
  ['']   = { key = 'VISUAL',    display = 'V-BLOCK' },
  ['s']    = { key = 'SELECT',    display = 'S' },
  ['S']    = { key = 'SELECT',    display = 'S-LINE' },
  ['']   = { key = 'SELECT',    display = 'S-BLOCK' },
  ['i']    = { key = 'INSERT',    display = 'I' },
  ['ic']   = { key = 'INSERT',    display = 'I' },
  ['ix']   = { key = 'INSERT',    display = 'I' },
  ['R']    = { key = 'REPLACE',   display = 'R' },
  ['Rc']   = { key = 'REPLACE',   display = 'R' },
  ['Rv']   = { key = 'REPLACE',   display = 'V-R' },
  ['Rx']   = { key = 'REPLACE',   display = 'R' },
  ['c']    = { key = 'COMMAND',   display = 'C' },
  ['cv']   = { key = 'EX',        display = 'EX' },
  ['ce']   = { key = 'EX',        display = 'EX' },
  ['r']    = { key = 'REPLACE',   display = 'R' },
  ['rm']   = { key = 'MORE',      display = 'MORE' },
  ['r?']   = { key = 'CONFIRM',   display = 'CONFIRM' },
  ['!']    = { key = 'SHELL',     display = 'SHELL' },
  ['t']    = { key = 'TERM',      display = 'T' },
}
function get_mode()
  local code = vim.fn.mode()
  return mode_map[code] or { key = 'DEFAULT', display = code }
end

-- Given name of a hlgroup return { fg = '#xxxxxx', bg = '#xxxxxx' } or nil
function get_hlcolors(hlgroup_name)
  local ok, color = pcall(vim.api.nvim_get_hl_by_name, hlgroup_name, true)
  if color ~= nil and color.background ~= nil then
    color.bg = string.format('#%06x', color.background)
    color.background = nil
  end
  if color ~= nil and color.foreground ~= nil then
    color.fg = string.format('#%06x', color.foreground)
    color.foreground = nil
  end
  if ok then return color end
end

function stlhl(group_name, str) return '%#' .. group_name .. '#' .. str end

function get_filetype(bufnr, hlgroup_name)
  local base_hlcolors = get_hlcolors(hlgroup_name)
  local full_file_name = vim.api.nvim_buf_get_name(bufnr)
  local f_name = string.match(full_file_name, '[^/]+$')
  local f_extension = string.match(full_file_name, '[^.]+$')
  local icon, icon_hlgroup_name = devicons.get_icon(f_name, f_extension)
  local icon_hlcolors = get_hlcolors(icon_hlgroup_name)
  local filetype = vim.bo[bufnr].filetype
  if (icon == nil) then
    return filetype
  elseif (icon_hlcolors == nil) then
    return icon .. ' ' .. filetype
  else
    local stl_icon_hlgroup_name = hlgroup_name .. icon_hlgroup_name
    vim.cmd(
      'highlight ' .. stl_icon_hlgroup_name
      .. ' guifg=' .. (icon_hlcolors.fg or 'NONE')
      .. ' guibg=' .. (base_hlcolors.bg or 'NONE')
    )
    return stlhl(stl_icon_hlgroup_name, icon) .. stlhl(hlgroup_name, ' ' .. filetype)
  end
end

function get_branch(bufnr)
  local buf_dir = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':h')
  local j = Job:new({
    command = "git", args = {"branch", "--show-current"}, cwd = buf_dir,
  })
  local ok, result = pcall(function() return vim.trim(j:sync()[1]) end)
  if ok then
    return result
  end
end

local c = require('onedark.colors')
function statusline_colors()
  return {
    base = { fg = c.fg, bg = c.bg1 },
    accent = { fg = c.fg, bg = c.dark_cyan },
    secondary = { fg = c.fg, bg = c.bg3 },
    err = c.dark_red,
    warning = c.dark_yellow,
    info = c.dark_cyan,
  }
end

function update_highlight_groups(colors)
  vim.cmd('highlight StlBase guifg=' .. colors.base.fg .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight StlAccent guifg=' .. colors.accent.fg .. ' guibg=' .. colors.accent.bg)
  vim.cmd('highlight StlSecondary guifg=' .. colors.secondary.fg .. ' guibg=' .. colors.secondary.bg)
  vim.cmd('highlight StlAccentSecondarySep guifg=' .. colors.accent.bg .. ' guibg=' .. colors.secondary.bg)
  vim.cmd('highlight StlSecondaryBaseSep guifg=' .. colors.secondary.bg .. ' guibg=' .. colors.base.bg)
end

-- TODO move to seperate file
-- TODO ALE Details
-- TODO Trailing whitespace/mixed indent
-- TODO Color switching
-- TODO crypt/spell/paste/insert ??
-- TODO on highlight num lines/words
function _G.statusline()
  local winid = vim.g.statusline_winid
  local bufnr = vim.fn.winbufnr(winid)

  local colors = statusline_colors()
  update_highlight_groups(colors)

  local rsep = ''
  local lsep = ''
  local spacer = '%='
  local filename = '%t'
  local progress = '%p%%'
  local filetype = get_filetype(bufnr, 'StlBase')
  local position = '%l:%-2c %L☰'
  local mode = get_mode()
  local branch_name = get_branch(bufnr)
  local branch_text = ''
  if branch_name then branch_text = '  ' .. branch_name end
  if string.len(branch_text) > 15 then
    branch_text = string.sub(branch_text, 1, 15) .. '..'
  end
  return (
    stlhl('StlAccent', ' ' .. mode.display .. ' ')
    .. stlhl('StlAccentSecondarySep', rsep)
    .. stlhl('StlSecondary', branch_text)
    .. stlhl('StlSecondaryBaseSep', rsep)
    .. stlhl('StlBase', ' ' .. filename .. spacer .. filetype .. ' ')
    .. stlhl('StlSecondaryBaseSep', lsep)
    .. stlhl('StlSecondary', ' ' .. progress .. ' ')
    .. stlhl('StlAccentSecondarySep', lsep)
    .. stlhl('StlAccent', ' ' .. position .. ' ')
  )
end
vim.o.statusline = '%!v:lua.statusline()'
EOF


" PLUGIN LUALINE
" search for trailing whitespace: [ \t]\+$  
" search for mixed indent
lua << EOF
--[[
function wordcount() return vim.fn.wordcount().words .. ' words' end
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
