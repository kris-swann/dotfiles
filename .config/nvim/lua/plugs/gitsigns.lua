local set = vim.keymap.set

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = {
        hl = 'GitSignsAdd',
        text = '│',
        numhl = 'GitSignsAddNr',
        linehl = 'GitSignsAddLn',
      },
      change = {
        hl = 'GitSignsChange',
        text = '│',
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn',
      },
      delete = {
        hl = 'GitSignsDelete',
        text = '│',
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn',
      },
      topdelete = {
        hl = 'GitSignsDelete',
        text = '│',
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn',
      },
      changedelete = {
        hl = 'GitSignsChange',
        text = '│',
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn',
      },
      untracked = {
        hl = 'GitSignsUntracked',
        text = '┆',
        numhl = 'GitSignsUntrackedNr',
        linehl = 'GitSignsUntrackedLn',
      },
    },
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    max_file_length = 40000, -- Disable if file is longer than this
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    worktrees = {
      {
        -- Gitsigns in dotfiles!
        toplevel = vim.env.HOME,
        gitdir = vim.env.HOME .. '/Projects/dotfiles',
      },
    },
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(bufnr)
      local gs = require('gitsigns')

      -- Navigation
      set('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Next [C]hanged hunk' })
      set('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.prev_hunk()
        end
      end, { desc = 'Prev [C]hanged hunk' })

      -- Which-key prefixes
      pcall(require('which-key').register, {
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        ['<leader>ht'] = { name = '[T]oggle', _ = 'which_key_ignore' },
      })
      pcall(require('which-key').register, {
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      }, { mode = 'v' })

      -- Actions
      set('n', '<leader>hs', gs.stage_hunk, { desc = '[S]tage hunk' })
      set(
        'v',
        '<leader>hs',
        function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = '[S]tage hunk' }
      )
      set('n', '<leader>hr', gs.reset_hunk, { desc = '[R]evert hunk' })
      set(
        'v',
        '<leader>hr',
        function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = '[R]eset hunk' }
      )
      set('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[U]nstage hunk' })
      set('n', '<leader>hp', gs.preview_hunk, { desc = '[P]review hunk' })
      set(
        'n',
        '<leader>hb',
        function() gs.blame_line({ full = true }) end,
        { desc = 'Full [B]lame for cur line' }
      )
      set('n', '<leader>hd', gs.diffthis, { desc = '[D]iffthis' })
      set('n', '<leader>hD', function() gs.diffthis('~') end, { desc = '[D]iffthis ~' })

      set('n', '<leader>htb', gs.toggle_current_line_blame, { desc = 'Toggle git line [B]lame' })
      set('n', '<leader>htd', gs.toggle_deleted, { desc = ' Toggle showing git [D]eleted' })

      -- Text object
      set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  },
}
