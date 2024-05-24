--
-- NOTE: To see telescope keymaps, use <Ctrl-/> in Insert mode or ? in Normal mode
--

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable('make') == 1 end,
    },
    'nvim-telescope/telescope-ui-select.nvim', -- Sets vim.ui.select to telescope
    'xiyaowong/telescope-emoji.nvim', -- Emoji picker
  },
  config = function()
    local set = vim.keymap.set
    local cmd = vim.api.nvim_create_user_command

    require('telescope').setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Enable extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'emoji')
    pcall(require('telescope').load_extension, 'yank_history')

    -- Which-key prefixes
    pcall(require('which-key').register, {
      [','] = { name = 'Search/Telescope', _ = 'which_key_ignore' },
      [',g'] = { name = '[G]it', _ = 'which_key_ignore' },
      [',d'] = { name = '[D]iagnostics', _ = 'which_key_ignore' },
    })

    local builtin = require('telescope.builtin')

    -- Resume last search
    set('n', ',,', builtin.resume, { desc = 'Resume Last Search' })

    -- Misc finders
    set('n', ',t', builtin.builtin, { desc = '[T]elescope Finders' })
    set('n', ',h', builtin.help_tags, { desc = '[H]elp' })
    set('n', ',k', builtin.keymaps, { desc = '[K]eymaps' })

    set(
      'n',
      ',p',
      function() require('telescope').extensions.yank_history.yank_history() end,
      { desc = '[P]aste from yank history' }
    )

    -- File and buffer finders
    set('n', ',b', builtin.buffers, { desc = 'Open [B]uffers' })
    set('n', ',m', builtin.marks, { desc = '[M]arks' })
    set('n', ',.', builtin.oldfiles, { desc = 'Recent Files ("." for repeat)' })
    set(
      'n',
      ',f',
      function() builtin.find_files({ no_ignore = true, hidden = true }) end,
      { desc = 'Find [F]iles' }
    )

    -- Grep finders
    set('n', ',w', builtin.grep_string, { desc = 'Grep [w]ord under cursor' })
    set(
      'v',
      ',w',
      function() return builtin.grep_string({ search = require('utils.get_visual_selection')() }) end,
      { desc = 'Grep highlighted [w]ords' }
    )
    set('n', ',/', builtin.live_grep, { desc = 'Grep search [/]' })
    set('n', ',z', function()
      -- https://github.com/nvim-telescope/telescope.nvim/issues/564#issuecomment-786850829
      builtin.grep_string({
        shorten_path = true,
        word_match = '-w',
        only_sort_text = true,
        search = '',
      })
    end, { desc = 'Fu[z]zy grep' })
    set(
      'n',
      ',s',
      function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end,
      { desc = '[S]earch open files' }
    )
    set(
      'n',
      '<leader>/',
      function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      { desc = 'Fuzzy Search Current Buffer' }
    )
    cmd( -- Custom command to allow grepping for more than one word at a time
      'Rg',
      function(props)
        builtin.grep_string({
          search = props.args,
          use_regex = true,
        })
      end,
      { nargs = '*' }
    )

    -- Git
    set('n', ',gf', builtin.git_files, { desc = 'Git [F]iles' })
    set('n', ',gs', builtin.git_status, { desc = 'Git [S]tatus' })
    set('n', ',gb', builtin.git_branches, { desc = 'Git [B]ranches' })
    set('n', ',gh', builtin.git_bcommits, { desc = 'Git [H]istory for cur file' })
    set('n', ',gl', builtin.git_commits, { desc = 'Git Commits [L]og' })

    -- Diagnostics finders
    set(
      'n',
      ',dd',
      function() builtin.diagnostics({ bufnr = 0 }) end, -- 0 for cur buf
      { desc = 'Current Buffer Diagnostics' }
    )
    set('n', ',da', builtin.diagnostics, { desc = '[A]ll Diagnostics' })
  end,
}
