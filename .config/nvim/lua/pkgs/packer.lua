local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto source and recompile anytime a file in the pkgs dir is saved
augroup('packer-recompile', { clear = true })
autocmd({ 'BufWritePost' }, {
  group = 'packer-recompile',
  pattern = { '**/pkgs/*.lua' },
  command = [[source <afile> | PackerCompile]],
})

-- Download and install packer.nvim if not already present
local ensure_packer = function()
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
      'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd[[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_installed = ensure_packer()

-- Helper function to cutdown on boilerplate when setting config
-- conf('name') is the same as function() require('pkgs.name') end
local conf = function(name)
  -- Can't actually call require here so have to return require string instead ¯\_(ツ)_/¯
  return string.format("require('pkgs.%s')", name)
end

return require('packer').startup({ function(use)
  use('wbthomason/packer.nvim')  -- Packer can manage itself

  use('lewis6991/impatient.nvim')  -- Faster startups

  use('editorconfig/editorconfig-vim')  -- Support for .editorconfig config files (not needed since 0.9)

  use('godlygeek/tabular')  -- Table formatting

  use('tpope/vim-fugitive')   -- Git wrapper
  use('tpope/vim-surround')   -- Manage "surrounding" parentheses, brackets, quotes, etc.  TODO investigate vim-sandwich
  use('tpope/vim-commentary') -- Comment stuff out  TODO investigate Comment.nvim
  use('tpope/vim-unimpaired') -- Bracket mappings []
  use('tpope/vim-repeat')     -- Make repeat (.) work with plugins
  use('tpope/vim-abolish')    -- Working with variations of words
  use('tpope/vim-eunuch')     -- Change ftype after writing shebang, and other unix sugar

  use({
    'gbprod/yanky.nvim',  -- Yank/paste ring and history (alternatives vim-yoink, nvim-neoclip)
    config = conf('yanky'),
  })

  use({
    'nacro90/numb.nvim',  -- Peek lines when typing like :1234
    config = function() require('numb').setup() end,
  })

  use({
    'folke/zen-mode.nvim', -- Goyo style plugin
    config = conf('zen_mode'),
  })

  use({
    'ggandor/leap.nvim',  -- Easymotion-like plugin inspired by sneak and lightspeed
    config = conf('leap')
  })

  -- use({
  --   'epwalsh/obsidian.nvim',  -- For better note-taking TODO: eval
  --   config = conf('obsidian'), -- Not setting up just want the nicer syntax higlighting
  -- })
  use({
    -- 'ekickx/clipboard-image.nvim',  -- Alows pasting images from clipboard
    -- Waiting on https://github.com/ekickx/clipboard-image.nvim/pull/48
    'postfen/clipboard-image.nvim',
    branch = 'patch-1',
    config = conf("clipboard_image"),
  })

  use({
    'lewis6991/gitsigns.nvim',  -- Git status highlights in sidebar
    tag = 'v0.5',
    config = conf('gitsigns'),
  })

  use({
    'stevearc/oil.nvim',  -- vidir like file browser, treats dirs like text files
    config = conf('oil')
  })

  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.0', -- Fuzzy finders
    requires = {
      {
        'nvim-telescope/telescope-fzf-native.nvim', -- Faster searches and better search syntax
        run = 'make'
      },
      'nvim-lua/plenary.nvim',                      -- Required lib
      'kyazdani42/nvim-web-devicons',               -- File icons
      'xiyaowong/telescope-emoji.nvim',             -- Picker: Emoji
      'keyvchan/telescope-find-pickers.nvim',       -- Picker: ALL (both builtin & extensions) pickers
    },
    after = {
      'yanky.nvim',  -- Picker: Yank ring/history
    },
    config = conf('telescope')
  })

  use({
    'williamboman/mason.nvim',  -- Auto install lsp, dap, linters, formatters, etc
    requires = {
      'williamboman/mason-lspconfig.nvim',  -- Integrate mason with lspconfig
      'jayp0521/mason-null-ls.nvim',        -- Integrate mason with null-ls
    },
    config = conf('mason')
  })

  use({
    'neovim/nvim-lspconfig',  -- Base configs for lsps
    -- tag = 'v0.1.3',  This tag is incompatible with latest null-ls (null-ls.nvim/issues/1106)
    requires = {
      'j-hui/fidget.nvim',          -- Lsp loading indicator
      'folke/neodev.nvim',          -- Additional lsp config for lua nvim apis
      { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } },  -- Turn commandline utils into lsps
      { 'folke/trouble.nvim' , requires = { 'kyazdani42/nvim-web-devicons' } },       -- Lsp info lists  TODO eval
    },
    after = { 'mason.nvim' },
    config = conf('lsp'),
  })

  use({
    'hrsh7th/nvim-cmp',           -- Base completion engine
    requires = {
      'onsails/lspkind.nvim',     -- Pictograms for different lsp obj types
      'hrsh7th/cmp-buffer',       -- Source: buffer words
      'hrsh7th/cmp-path',         -- Source: filesystem paths
      'hrsh7th/cmp-cmdline',      -- Source: command line completions
      'hrsh7th/cmp-omni',         -- Source: omnifunc
      'saadparwaiz1/cmp_luasnip', -- Source: luasnips
      'hrsh7th/cmp-nvim-lsp',     -- Source: LSP
      -- 'rcarriga/cmp-dap',         -- Source: DAP
      { 'L3MON4D3/LuaSnip', tag = 'v1.1.0' },   -- Must have at least one snippet source
    },
    config = conf('cmp'),
  })

  use({
    'nvim-treesitter/nvim-treesitter',  -- Base Treesitter
    branch = 'v0.9.0',
    -- run = ':TSUpdate',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    requires = {
      'nvim-treesitter/playground',               -- View treesitter info and highlight groups
      'nvim-treesitter/nvim-treesitter-context',  -- Sticky context header
    },
    config = conf('treesitter'),
  })

  -- -- Debug adapter protocol (dap) TODO eval
  -- use('mfussenegger/nvim-dap')
  -- use('rcarriga/nvim-dap-ui')
  -- use('theHamsta/nvim-dap-virtual-text')

  use({
    'nvim-lualine/lualine.nvim', -- Statusline
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = conf('lualine'),
  })

  use({
    'lukas-reineke/indent-blankline.nvim', -- Indent guides
    config = conf('indent_blankline'),
  })

  -- use({
  --   'NTBBloodbath/rest.nvim', -- Rest client TODO eval
  --   requires = { 'nvim-lua/plenary.nvim' },
  -- })

  -- Colorschemes
  use({ 'folke/tokyonight.nvim',      as='tokyonight' })
  -- use({ 'navarasu/onedark.nvim',      as='onedark' })
  -- use({ 'gruvbox-community/gruvbox',  as='gruvbox' })
  -- use({ 'catppuccin/nvim',            as='catppuccin' })
  -- use({ 'rose-pine/neovim',           as='rose-pine' })

  use({
    'uga-rosa/ccc.nvim', -- Color picker
    config = conf('ccc')
  })

  -- Automatically sync after fresh-installing packer.nvim (must be after all other plugins)
  if packer_installed then
    require('packer').sync()
  end
end,
-- Packer config
config = {
  display = {
    open_fn = function()
      -- Show in single-border popup
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
