lua << EOF
vim.g.mapleader = ','      -- set leader as early as possible (in case plugins set keybinds w/ leader)
keymap = vim.api.nvim_set_keymap  -- shortcut for setting keymaps

-- Rebuild *.spl files if necessary (see https://a3nm.net/blog/git_auto_conflicts.html)
for _, add_file in ipairs(vim.fn.glob('~/.config/nvim/spell/*.add', 1, 1)) do
    local spl_file = add_file .. '.spl'
    local spl_outdated = vim.fn.getftime(add_file) > vim.fn.getftime(spl_file)
    if not vim.fn.filereadable(spl_file) or spl_outdated then
      vim.cmd('silent mkspell! ' .. add_file)
    end
end

-- Download and install packer.nvim if not already present
local packer_nvim_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_nvim_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_nvim_path})
  vim.api.nvim_command('packadd packer.nvim')
end

-- TODO evaluate vimagit
-- TODO ternjs
-- TODO does ale still make sense? (efm-langserver vs diagnostic-languageserver vs null-ls.nvim)
-- TODO replace fzf with  telescope
-- TODO is vim-dispatch even needed any more?
-- TODO evaluate RRethy/nvim-treesitter-textsubjects
-- TODO evaluate nvim-treesitter/nvim-treesitter-textobjects
-- TODO write own colorscheme
-- TODO check out plumb feature
-- TODO switch all ftplugin indent changes over to a base .editorconfig file
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'svermeulen/vim-yoink',
    config=function()
      keymap('n', '<C-n>', '<plug>(YoinkPostPasteSwapForward)', {})
      keymap('n', '<C-p>', '<plug>(YoinkPostPasteSwapBack)', {})
      keymap('n', 'p', '<plug>(YoinkPaste_p)', {})
      keymap('n', 'P', '<plug>(YoinkPaste_P)', {})
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        ignore_install = {"haskell", "phpdoc"}, -- can't compile atm
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = [[\]],
            node_decremental = [[|]],
          },
        },
      }
    end
  }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')

      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }
        -- TODO better keybinds
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      end

      -- For install info/all supported lsp's :help lspconfig-all
      local servers = {
        'pyright',
        'prismals',
        'tsserver',
        'eslint',
        'graphql',
        'rust_analyzer',
        'java_language_server',
        'jdtls',
      }
      for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
          on_attach = on_attach,
          flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
          }
        }
      end
    end
  }
  use 'tpope/vim-commentary'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-abolish'
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-ula/plenary.nvim',
    config = function()
      require'gitsigns'.setup{
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'   },
          change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          delete       = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          topdelete    = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          changedelete = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, opts)
              opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
              vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
          end

          -- Navigation
          map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
          map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

          -- Actions
          map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
          --map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
          map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
          --map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
          map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
          map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
          map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
          map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
          map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
          map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

          -- Text object
          map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  }
  use {
    'rrethy/vim-hexokinase',
    run = 'make hexokinase',
    config = function()
      vim.g.Hexokinase_highlighters = {'virtual'}
      vim.g.Hexokinase_optInPatterns = {'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names'}
    end
  }
  -- use 'psliwka/vim-smoothie'
  use { 'nacro90/numb.nvim', config = function() require'numb'.setup() end }
  use {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      require'hop'.setup {
        keys = 'danesirhculofypmgvbw',
      }
      keymap('', '<space><space>', '<cmd>lua require"hop".hint_char1({ multi_windows = true })<CR>', {})
      keymap('', '<space>w', '<cmd>lua require"hop".hint_words({ multi_windows = true })<CR>', {})
      keymap('', '<space>l', '<cmd>lua require"hop".hint_lines({ multi_windows = true })<CR>', {})
      keymap('', '<space>/', '<cmd>lua require"hop".hint_patterns({ multi_windows = true })<CR>', {})
    end
  }
  use 'godlygeek/tabular'
  use {
    'francoiscabrol/ranger.vim',
    requires = 'rbgrouleff/bclose.vim',
    config = function()
      vim.g.ranger_replace_netrw = 1
      vim.g.ranger_map_keys = 0
      keymap('n', '<leader>e', '<cmd>Ranger<CR>', {})
    end
  }
  use 'navarasu/onedark.nvim'
  use {
    'w0rp/ale',
    config = function()
      vim.g.ale_linters = {
        python = {'flake8', 'pylint'},
        typescript = {'eslint', 'prettier', 'standard', 'tslint', 'typecheck'},
      }
      -- Navigation
      keymap('n', '<C-k>', '<cmd>ALEPreviousWrap<CR>', { silent=true })
      keymap('n', '<C-j>', '<cmd>ALENextWrap<CR>', { silent=true })
      -- Nicer error messages
      vim.g.ale_echo_msg_error_str = 'E'
      vim.g.ale_echo_msg_warning_str = 'W'
      vim.g.ale_echo_msg_format = '[%severity%] [%linter%] %[code]% %s'
      vim.g.ale_virtualtext_cursor = 1
      -- Colors
      local c = require'onedark.colors'
      vim.cmd('highlight ALEErrorSign guifg=' .. c.dark_red .. ' guibg=' .. c.bg0)
      vim.cmd('highlight ALEWarningSign guifg=' .. c.dark_yellow .. ' guibg=' .. c.bg0)
      vim.cmd('highlight ALEInfoSign guifg=' .. c.dark_cyan .. ' guibg=' .. c.bg0)
      -- Gutter icons
      vim.g.ale_sign_error = ''
      vim.g.ale_sign_warning = ''
      vim.g.ale_sign_info = ''
      -- Python lint opts
      vim.g.ale_python_flake8_change_directory = 'off'
      -- Cpp lint opts
      vim.g.ale_cpp_clangtidy_options = '-Wall -std=c++11 -x c++'
      vim.g.ale_cpp_clangcheck_options = '-- -Wall -std=c++11 -x c++'
    end
  }
  use 'ambv/black'
  use 'Vimjas/vim-python-pep8-indent'
  use { 'prettier/vim-prettier',  run = 'npm install -g prettier' }
  use {
    'junegunn/fzf.vim',
    requires = {
      { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' },
    },
    config = function()
      vim.g.fzf_action = {
        ['ctrl-t'] = 'tab split',
        ['ctrl-s'] = 'split',
        ['ctrl-v'] = 'vsplit',
      }
      keymap('', '<leader>f', '<cmd>GitFiles<CR>', {})
      keymap('', '<leader>af', '<cmd>Files<CR>', {})
    end
  }
  use {
    'hrsh7th/nvim-compe',
    config=function()
      require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          border = { '', '' ,'', ' ', '', '', '', ' ' }, -- same as nvim_open_win
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };
        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
        };
      }
      -- keymap('i', '<C-space>', 'compe#complete()', { silent=true, expr=true })
      keymap('i', '<C-space>', 'compe#complete()', { noremap=true, silent=true, expr=true })
      keymap('i', '<CR>', [[compe#confirm('<CR>')]], { noremap=true, silent=true, expr=true })
      keymap('i', '<C-e>', [[compe#close('<C-e>')]], { noremap=true, silent=true, expr=true })
      keymap('i', '<C-f>', [[compe#scroll({ 'delta': +4 })]], { noremap=true, silent=true, expr=true })
      keymap('i', '<C-d>', [[compe#scroll({ 'delta': -4 })]], { noremap=true, silent=true, expr=true })
    end
  }
end)

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.signcolumn = 'yes'   -- always show signcolumn
vim.o.undofile = true      -- persist undos between sessions
vim.o.hidden = true        -- allow hidden buffers to be unsaved
vim.o.termguicolors = true -- use gui instead of cterm highlight colors
vim.o.scrolloff = 3

vim.o.wildmode = 'longest:full,full'  -- command mode completions: longest common substr then cycle options
vim.o.omnifunc = 'syntaxcomplete#Complete'  -- basic omnifunc for <C-x><C-o> completions
vim.o.completeopt = "menuone,noselect"

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

vim.o.foldmethod = 'manual'
keymap('n', [[\]], 'zD', { noremap = true })
keymap('v', [[\]], 'zf', { noremap = true })
vim.opt.foldtext = 'v:lua.foldtext()'
-- Note: these function are evaluated in the sandbox
function fold_is_modified()
  local gitsigns = vim.fn.sign_getplaced('', {group = 'gitsigns_ns'})[1].signs
  for _, signitem in ipairs(gitsigns) do
    local lnum = signitem.lnum
    if vim.v.foldstart <= lnum and lnum <= vim.v.foldend then return true end
  end
  return false
end
function _G.foldtext()
  local numlines = vim.v.foldend - vim.v.foldstart + 1
  local is_modified = fold_is_modified()
  local modified_char = is_modified and '⊡ ' or ''

  local righttext = modified_char .. '祉' .. numlines .. ' lines'
  -- Unicode chars screw up len, replace problem chars w/ spaces for accurate len
  local righttextlen = #(string.gsub(string.gsub(righttext, '⊡', ' '), '祉', '  '))

  local linetext = vim.fn.getline(vim.v.foldstart)
  local colwidth = 2  -- winwidth includes lefthand cols
  local maxlen = math.min(vim.fn.winwidth(0) - colwidth, vim.o.colorcolumn)
  local minspace = 2  -- at least this many spaces between linetext and righttext
  local maxlinetextlen = maxlen - righttextlen - minspace - 1
  if #linetext > maxlinetextlen then
    linetext = string.sub(linetext, 1, maxlinetextlen - 2) .. '..'
  end
  local fillcharcount = maxlen - #linetext - righttextlen - 1
  return linetext .. string.rep(" ", fillcharcount) .. righttext
end

require('onedark').setup {
  style = 'warm',
}
require('onedark').load()
-- TODO move this (and others) into setup?
local c = require'onedark.colors'
vim.cmd('highlight Folded gui=NONE guifg=' .. c.fg .. ' guibg=' .. c.dark_cyan)

-- STATUSLINE (TODO move to packer.nvim?)
statusline = require'statusline'
_G.make_statusline = statusline.make_statusline
vim.o.statusline = '%!v:lua.make_statusline()'

-- BASIC MAPPINGS
-- Prefer virtual replace over normal replace (plays nicer w/ tabs and eols)
keymap('n', 'R', 'gR', { noremap=true })
-- Disable Ex Mode
keymap('n', 'Q', '<Nop>', { noremap=true })
keymap('n', 'gQ', '<Nop>', { noremap=true })
-- Same movement in wrapped lines
keymap('n', 'j', 'gj', { noremap=true })
keymap('n', 'k', 'gk', { noremap=true })
-- Scrolling
keymap('n', '<C-e>', '5<C-e>', { noremap=true })
keymap('n', '<C-y>', '5<C-y>', { noremap=true })
keymap('n', 'zl', 'zL', { noremap=true })
keymap('n', 'zh', 'zH', { noremap=true })
-- Easy copy-pasting to and from system clipboard
keymap('', '<leader>y', [["+y]], { noremap=true })
keymap('', '<leader>d', [["+d]], { noremap=true })
keymap('', '<leader>p', [["+p]], { noremap=true })
keymap('', '<leader>P', [["+P]], { noremap=true })
-- Delete to blackhole register (lightweight vim-cutlass)
keymap('', '<leader>x', [["_d]], { noremap=true })
-- Easy exit out of terminal
keymap('t', '<esc>', [[<C-\><C-n>]], { noremap=true })
-- Clear search highlighting
keymap('n', '<esc>', '<cmd>noh<bar>lclose<bar>pclose<CR>', { noremap=true })
-- Reset sytax
keymap('n', '<leader>s', '<cmd>syntax sync fromstart<CR>', { noremap=true })
EOF


" BASIC COMMANDS, ABBREVS
" Shortcut to neovim config file
command! Config :e ~/.config/nvim/init.vim   
" Shortcut to notes
command! Notes :e ~/Notes/index.md
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


" FILE SPECIFIC CONFIG
" Update bindings when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
