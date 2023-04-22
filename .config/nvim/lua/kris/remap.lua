local set = vim.keymap.set

-- Prefer virtual replace over normal replace (plays nicer w/ tabs and eols)
set('n', 'R', 'gR')

-- Disable Ex Mode
set('n', 'Q', '<Nop>')
set('n', 'gQ', '<Nop>')

-- Swap movement for wrapped lines
set('n', 'j', 'gj')
set('n', 'k', 'gk')
set('n', '^', 'g^')
set('n', '$', 'g$')
set('n', 'gj', 'j')
set('n', 'gk', 'k')
set('n', 'g^', '^')
set('n', 'g$', '$')

-- Scrolling
set('n', '<C-e>', '5<C-e>')
set('n', '<C-y>', '5<C-y>')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', 'n', 'nzz')
set('n', 'G', 'Gzz')
set('n', 'zl', 'zL')
set('n', 'zh', 'zH')

-- Easy copy-pasting to and from system clipboard
set('', '<leader>y', [["+y]])
set('', '<leader>d', [["+d]])
set('', '<leader>p', [["+p]])
set('', '<leader>P', [["+P]])
-- Delete to blackhole register (lightweight vim-cutlass)
set('', '<leader>x', [["_d]])

-- Easy exit out of terminal
set('t', '<esc>', [[<C-\><C-n>]])

-- Clear search highlighting
set('n', '<esc>', '<cmd>noh<bar>lclose<bar>pclose<CR>')

set('n', '<leader><leader>t', '<cmd>tabe %<CR>')
set('n', '<leader><leader>T', '<C-W>T')

-- Insert date in insert mode
set('i', '<C-d>', "<C-r>=strftime('%F')<CR>")
set('i', '<C-M-d>', "<C-r>=strftime('%F: %a %b %-e, %Y')<CR>")
