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

  use('editorconfig/editorconfig-vim')  -- Support for .editorconfig config files

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
    'phaazon/hop.nvim',  -- Easymotion plugin  TODO eval
    branch = 'v2',
    config = conf('hop'),
  })

  use({
    'ggandor/leap.nvim',  -- Easymotion-like plugin TODO eval
    config = conf('leap')
  })

  use({
    'TimUntersberger/neogit',  -- Magit for neovim TODO eval
    requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    config = conf('neogit'),
  })

  use({
    'lewis6991/gitsigns.nvim',  -- Git status highlights in sidebar
    tag = 'v0.5',
    config = conf('gitsigns'),
  })

  use({
    'nvim-neo-tree/neo-tree.nvim',  -- Tree-based filebrowser TODO eval
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
  })

  use({
    'elihunter173/dirbuf.nvim',  -- Text-centric file manager
    config = conf('dirbuf')
  })

  use('mbbill/undotree')  -- Interact with undotree TODO eval

  use('ThePrimeagen/harpoon')  -- Better global marks TODO eval

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
    },
    config = conf('mason')
  })

  use({
    'neovim/nvim-lspconfig',  -- Configs for lsps
    tag = 'v0.1.3',
    requires = {
      'j-hui/fidget.nvim',  -- Lsp loading indicator
      'folke/neodev.nvim',  -- Additional config for nvim lua lsp (when in neovim config files)
      -- { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } }  -- Turn commandline utils into lsps TODO eval
      { 'folke/trouble.nvim' , requires = { 'kyazdani42/nvim-web-devicons' } }, -- Lsp info lists  TODO eval
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
      'saadparwaiz1/cmp_luasnip', -- Source: luasnips
      'hrsh7th/cmp-nvim-lsp',     -- Source: LSP
      'rcarriga/cmp-dap',         -- Source: DAP
      { 'L3MON4D3/LuaSnip', tag = 'v1.1.0' },   -- Must have at least one snippet source TODO eval
    },
    config = conf('cmp'),
  })

  use({
    'nvim-treesitter/nvim-treesitter',  -- Base Treesitter
    branch = 'v0.8.0',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/playground',               -- View treesitter info and highlight groups
      'nvim-treesitter/nvim-treesitter-context',  -- Sticky context header
    },
    config = conf('treesitter'),
  })

  -- Debug adapter protocol (dap) TODO eval
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  use({
    'nvim-lualine/lualine.nvim', -- Statusline TODO eval
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = conf('lualine'),
  })

  use({
    'lukas-reineke/indent-blankline.nvim', -- Indent guides
    config = conf('indent_blankline'),
  })

  use({
    'NTBBloodbath/rest.nvim', -- Rest client TODO eval
    requires = { 'nvim-lua/plenary.nvim' },
  })

  use({
    'edluffy/hologram.nvim',  -- Kitty term inline images (Experimental)
    config = conf('hologram'),
  })

  -- Colorschemes
  use({ 'folke/tokyonight.nvim',      as='tokyonight' })
  use({ 'navarasu/onedark.nvim',      as='onedark' })
  use({ 'gruvbox-community/gruvbox',  as='gruvbox' })
  use({ 'catppuccin/nvim',            as='catppuccin' })
  use({ 'rose-pine/neovim',           as='rose-pine' })

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
