-- Bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- Latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- End bootstrap lazy

local plugins = {

  { -- Colorscheme/theme
    'sainnhe/everforest',
    -- Other good themes: tokyonight, rose-pine, catppuccin, bamboo, flexoki
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = 'medium' -- hard | medium | soft
      vim.opt.background = 'light' -- light | dark
      vim.cmd.colorscheme('everforest') -- Must come after setting the settings
    end,
  },

  { -- Statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
    opts = {
      options = {
        theme = 'everforest',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            file_status = true, -- Readonly/modified
            newfile_status = true,
            path = 0, -- Filename only
            symbols = {
              modified = '[+]',
              readonly = '[RO]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
        },
        lualine_x = {
          'filetype',
          'codeium#GetStatusString',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  'tpope/vim-fugitive', -- Git wrapper
  'junegunn/gv.vim', -- Git commit browser
  require('plugs/gitsigns'), -- Git gutter signs

  'tpope/vim-sleuth', -- Autoset shiftwidth, tabstop, etc
  'tpope/vim-eunuch', -- :Delete :SudoWrite :Chmod and change ftype after typing shebang
  'tpope/vim-repeat', -- Make repeat (.) work with plugins
  'tpope/vim-rsi', -- Insert mode readline (emacs) bindings
  'tpope/vim-abolish', -- Working with variations of words

  { 'numToStr/Comment.nvim', opts = {} }, -- Comment toggles

  { 'nacro90/numb.nvim', opts = {} }, -- Peek lines via :1234

  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} }, -- Indent guidelines

  { -- Yank ring history
    'gbprod/yanky.nvim',
    config = function()
      require('yanky').setup({})
      local set = vim.keymap.set
      set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
      set({ 'n', 'x' }, 'p', '<plug>(YankyPutAfter)')
      set({ 'n', 'x' }, 'P', '<plug>(YankyPutBefore)')
      set({ 'n', 'x' }, 'gp', '<plug>(YankyGPutAfter)')
      set({ 'n', 'x' }, 'gP', '<plug>(YankyGPutBefore)')
    end,
  },

  {
    'folke/zen-mode.nvim',
    opts = {
      window = {
        backdrop = 1, -- Same color
        width = 75,
        -- vim.wo options to apply/disable
        options = {
          signcolumn = 'no',
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          colorcolumn = '',
          foldcolumn = '0',
          list = false, -- Whitespace chars
          wrap = false, -- Softwrap
          linebreak = true, -- Break at words instead of width
        },
      },
    },
    keys = { -- Lazy load until triggered
      { '<leader><leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle [Z]enMode' },
    },
  },

  { -- vidir/vim-vinegar like filebrowser, edit dirs like you edit text
    'stevearc/oil.nvim',
    opts = {
      columns = { 'icon', 'size', 'permissions' },
      delete_to_trash = true,
      constrain_cursor = 'name',
      view_options = {
        show_hidden = true,
      },
    },
    config = function(_, opts)
      require('oil').setup(opts)
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent dir' })
    end,
  },

  { -- Tree filebrowser TODO eval
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/playground', -- View treesitter info and highlight groups
      'nvim-treesitter/nvim-treesitter-context', -- Sticky context header
    },
    opts = {
      ensure_installed = 'all',
      ignore_install = {},
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn', -- Normal mode
          -- Visual mode
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
    },
    config = function(_, opts)
      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Align text (ga/gA)
      require('mini.align').setup()

      -- Swap between single & multi line args layouts with gS
      require('mini.splitjoin').setup()

      -- Highlight inline text
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
      vim.api.nvim_set_hl(0, 'MiniHipatternsFixme', { link = 'TSDanger' })
      vim.api.nvim_set_hl(0, 'MiniHipatternsHack', { link = 'TSWarning' })
      vim.api.nvim_set_hl(0, 'MiniHipatternsTodo', { link = 'TSTodo' })
      vim.api.nvim_set_hl(0, 'MiniHipatternsNote', { link = 'TSNote' })

      -- Minimap
      local minimap = require('mini.map')
      require('mini.map').setup({
        integrations = {
          minimap.gen_integration.builtin_search(),
          minimap.gen_integration.gitsigns(),
          minimap.gen_integration.diagnostic(),
        },
      })
      local set = vim.keymap.set
      pcall(require('which-key').register, {
        ['<leader>m'] = { name = '[M]inimap', _ = 'which_key_ignore' },
      })
      set('n', '<leader>mm', minimap.toggle, { desc = 'Toggle Minimap' })
      set('n', '<leader>mf', minimap.toggle_focus, { desc = 'Toggle Minimap [F]ocus' })
      set('n', '<leader>ms', minimap.toggle_side, { desc = 'Toggle Minimap [S]ide' })
      set('n', '<leader>mr', minimap.refresh, { desc = '[R]efresh Minimap' })
    end,
  },

  require('plugs/telescope'),
  require('plugs/lsp'),
  require('plugs/autocompletion'),
  require('plugs/autoformat'),
  require('plugs/lint'),
  require('plugs/dap'),
}

local opts = {}

require('lazy').setup(plugins, opts)

--------------------------------------------------
-- Plugins I want to keep a note of
--------------------------------------------------
-- tpope/vim-unimpaired -- Bracket mappings [] (Didn't use it)
-- ggandor/leap.nvim -- Easymotion-like plugin (Didn't use it when I tried it, conflicting keybinds)
-- ThePrimeagen/harpoon -- Better Marks (Also mini.visits) (Maybe marks & altfile will be enough)
-- folke/trouble.nvim -- LSP info lists (Not sure I need it)
-- mfussenegger/nvim-dap 'rcarriga/nvim-dap-ui' 'theHamsta/nvim-dap-virtual-text' -- DAP plugins
-- onsails/lspkind.nvim -- LSP Pictograms (Didn't seem to add a whole lot)
--
-- uga-rosa/ccc.nvim -- Color picker (Better suited by diff tool)
-- tpope/vim-dadbod kristijanhusak/vim-dadbod-ui -- SQL editor (Better suited by diff tool)
-- NTBBloodbath/rest.nvim, -- Rest client (Better suited by diff tool)
--
-- epwalsh/obsidian.nvim, -- Obsidian notes (I just use obsidian now)
-- HakonHarnes/img-clip.nvim, -- Paste image from clipboard (I just use obsidian now)
-- masukomi/vim-markdown-folding -- (Not writing super long md files anymore)
-- cappyzawa/starlark.vim -- Starlark syntax (Not using anymore)
--
--------------------------------------------------
-- Replaced Plugins
--------------------------------------------------
-- junegunn/vim-peekaboo -- See register contents before inserting (Replaced by which-key)
-- junegunn/goyo.vim -- (Replaced by zen-mode)
-- lewis6991/impatient.nvim -- Faster startups (Replaced by vim.loader.enable())
-- editorconfig/editorconfig-vim -- (Built into nvim since 0.9.0)
-- tpope/vim-surround -- Manage surrounding brackets, quotes, etc. (Replaced by mini.ai/mini.surround)
-- godlygeek/tabular -- Table formatting (Replaced by mini.align)
--jose-elias-alvarez/null-ls.nvim (Unmaintained, moved to nvim-lint)
--jayp0521/mason-null-ls.nvim -- Autoinstall null-ls sources with mason (Stopped using null-ls)
--------------------------------------------------
-- Nvim distros to checkin with from time to time
--------------------------------------------------
-- nvim-lua/kickstart.nvim  -- Lightweight starting point
-- LunarVim/LunarVim  -- Batteries included distro
-- AstroNvim/AstroNvim  -- Batteries included distro
-- NvChad/NvChad  -- Batteries included distro
--------------------------------------------------
