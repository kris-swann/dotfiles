local set = vim.keymap.set

-- NOTE: Remember that you can use <C-^> to switch to alternate file

-- Set leader (Must be set before keybinds & plugins, otherwise will use old leader)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Prefer virtual replace over normal replace (plays nicer w tabs and eols)
set('n', 'R', 'gR')

-- Disable Ex Mode
set('n', 'Q', '<Nop>')
set('n', 'gQ', '<Nop>')

-- Swap g movement for wrapped lines
set('n', 'j', 'gj')
set('n', 'k', 'gk')
set('n', '^', 'g^')
set('n', '$', 'g$')
set('n', 'gj', 'j')
set('n', 'gk', 'k')
set('n', 'g^', '^')
set('n', 'g$', '$')

-- Folding (za is awkward to type)
set('n', 'z<space>', 'za')
set('n', 'z<S-space>', 'zA')

-- Scrolling
set('n', '<C-e>', '5<C-e>')
set('n', '<C-y>', '5<C-y>')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', 'n', 'nzz')
set('n', 'G', 'Gzz')
set('n', 'zl', 'zL')
set('n', 'zh', 'zH')

-- Clear search highlights
set('n', '<esc>', '<cmd>nohlsearch<CR>') -- Used to be '<cmd>noh<bar>lclose<bar>pclose<CR>'

-- Tabs
set('n', '<leader><leader>t', '<cmd>tabe %<CR>', { desc = 'Open current window in new [T]ab' })
set('n', '<leader><leader>T', '<C-W>T', { desc = 'Move current window to new [T]ab' })

-- Terminal
set('t', '<esc><esc>', [[<C-\><C-n>]], { desc = 'Easy exit terminal' })

-- Copy pasting
set('', '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
set('', '<leader>d', [["+d]], { desc = 'Delete to system clipboard' })
set('', '<leader>p', [["+p]], { desc = 'Paste from system clipboard' })
set('', '<leader>P', [["+P]], { desc = 'Paste from system clipboard' })
set('', '<leader>x', [["_d]], { desc = 'Delete to blackhole register' })

-- Dates
set('i', '<C-M-d>', [[<C-r>=strftime('%F')<CR>]], { desc = 'Insert [D]ate 2024-06-08' })
set('i', '<C-M-e>', [[<C-r>=strftime('%s')<CR>]], { desc = 'Insert [E]poch 1686253849' })

-- Diagnostics (Intentionally seperate from lsp and telescope configs)
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev [D]iagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next [D]iagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
