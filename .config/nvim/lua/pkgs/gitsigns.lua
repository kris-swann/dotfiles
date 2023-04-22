local set = vim.keymap.set

require('gitsigns').setup({
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
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
    col = 1
  },
  worktrees = {
    {
      -- Gitsigns in dotfiles!
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME..'/Projects/dotfiles',
    },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation
    set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    set('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    set('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    set('n', '<leader>hu', gs.undo_stage_hunk)
    set('n', '<leader>hp', gs.preview_hunk)
    set('n', '<leader>hb', function() gs.blame_line{full=true} end)
    set('n', '<leader>tb', gs.toggle_current_line_blame)
    set('n', '<leader>hd', gs.diffthis)
    set('n', '<leader>hD', function() gs.diffthis('~') end)
    set('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    set('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    set('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
