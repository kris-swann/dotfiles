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

return require('packer').startup({ function(use)
  use('wbthomason/packer.nvim')  -- Packer can manage itself

  use('lewis6991/impatient.nvim')  -- Faster startups

  use('editorconfig/editorconfig-vim')  -- Support for .editorconfig config files

  use('godlygeek/tabular')  -- Table formatting

  use('tpope/vim-fugitive')   -- Git wrapper
  use('tpope/vim-surround')   -- Manage "surrounding" parentheses, brackets, quotes, etc.
  use('tpope/vim-commentary') -- Comment stuff out
  use('tpope/vim-unimpaired') -- Bracket mappings []
  use('tpope/vim-repeat')     -- Make repeat (.) work with plugins
  use('tpope/vim-abolish')    -- Working with variations of words

  use('svermeulen/vim-yoink')  -- Paste history

  use('nacro90/numb.nvim')  -- Peek lines when typing like :1234

  use({ 'phaazon/hop.nvim', branch = 'v2' })  -- Easymotion plugin  TODO eval

  use('ggandor/leap.nvim')  -- Easymotion-like plugin TODO eval

  -- Magit for neovim TODO eval
  use({
    'TimUntersberger/neogit',
    requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
  })

  use({ 'lewis6991/gitsigns.nvim', tag = 'v0.5' })  -- Git status highlights in sidebar

  -- Tree-based filebrowser TODO eval
  use({
    'nvim-neo-tree/neo-tree.nvim', branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    }
  })

  use('elihunter173/dirbuf.nvim')  -- Text-centric file manager

  use('mbbill/undotree')  -- Interact with undotree TODO eval

  use('ThePrimeagen/harpoon')  -- Better global marks TODO eval

  -- Fuzzy finders
  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires={ 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons' }
  })
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })  -- Faster and better search syntax
  use('xiyaowong/telescope-emoji.nvim')
  use('nvim-telescope/telescope-file-browser.nvim')  -- TODO eval

  -- Language server protocol (lsp)
  use({ 'neovim/nvim-lspconfig', tag = 'v0.1.3' })  -- Configs for lspspacker
  use('folke/neodev.nvim')  -- Config for nvim lua lsps
  -- use({ 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } })  -- Turn commandline utils into lsps TODO eval
  use('j-hui/fidget.nvim')  -- Lsp loading indicator
  use('onsails/lspkind.nvim')  -- Pictograms for different lsp object types

  -- Snippets (nvim-cmp needs at least one snippet source)
  use({ 'L3MON4D3/LuaSnip', tag = 'v1.1.0' })  -- TODO eval

  -- Auto-completions  TODO eval
  use({
    'hrsh7th/nvim-cmp',           -- Base completion engine
    requires = {
      'hrsh7th/cmp-buffer',       -- Source: buffer words
      'hrsh7th/cmp-path',         -- Source: filesystem paths
      'hrsh7th/cmp-cmdline',      -- Source: command line completions
      'saadparwaiz1/cmp_luasnip', -- Source: luasnips
      'hrsh7th/cmp-nvim-lsp',     -- Source: LSP
      'rcarriga/cmp-dap',         -- Source: DAP
    },
  })

  use({ 'nvim-treesitter/nvim-treesitter', branch = 'v0.8.0', run = ':TSUpdate' })  -- Base treesitter
  use('nvim-treesitter/playground')  -- View treesitter info and highlight groups
  use('nvim-treesitter/nvim-treesitter-context')  -- Sticky header

  -- Debug adapter protocol (dap) TODO eval
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  use({ 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons' } })  -- Statusline TODO eval

  use('lukas-reineke/indent-blankline.nvim')  -- Indent guides

  use({ "NTBBloodbath/rest.nvim", requires = { "nvim-lua/plenary.nvim" } }) -- Rest client TODO eval

  use('uga-rosa/ccc.nvim') -- Color picker

  use('edluffy/hologram.nvim')  -- Kitty term inline images (Expirimental)

  -- Colorschemes
  use('folke/tokyonight.nvim')
  use('navarasu/onedark.nvim')
  use('gruvbox-community/gruvbox')
  use({ 'catppuccin/nvim', as='catppuccin' })
  use({ 'rose-pine/neovim', as='rose-pine' })

  -- Automatically sync after fresh-installing packer.nvim (must be after all other plugins)
  if packer_installed then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
