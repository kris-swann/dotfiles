local noremap = require('utils.keymap').noremap
local nnoremap = require('utils.keymap').nnoremap
local tnoremap = require('utils.keymap').tnoremap

-- Prefer virtual replace over normal replace (plays nicer w/ tabs and eols)
nnoremap('R', 'gR')

-- Disable Ex Mode
nnoremap('Q', '<Nop>')
nnoremap('gQ', '<Nop>')

-- Swap movement for wrapped lines
nnoremap('j', 'gj')
nnoremap('k', 'gk')
nnoremap('^', 'g^')
nnoremap('$', 'g$')
nnoremap('gj', 'j')
nnoremap('gk', 'k')
nnoremap('g^', '^')
nnoremap('g$', '$')

-- Scrolling
nnoremap('<C-e>', '5<C-e>')
nnoremap('<C-y>', '5<C-y>')
nnoremap('<C-d>', '<C-d>zz')
nnoremap('<C-u>', '<C-u>zz')
nnoremap('n', 'nzz')
nnoremap('G', 'Gzz')
nnoremap('zl', 'zL')
nnoremap('zh', 'zH')

-- Easy copy-pasting to and from system clipboard
noremap('<leader>y', [["+y]])
noremap('<leader>d', [["+d]])
noremap('<leader>p', [["+p]])
noremap('<leader>P', [["+P]])
-- Delete to blackhole register (lightweight vim-cutlass)
noremap('<leader>x', [["_d]])

-- Easy exit out of terminal
tnoremap('<esc>', [[<C-\><C-n>]])

-- Clear search highlighting
nnoremap('<esc>', '<cmd>noh<bar>lclose<bar>pclose<CR>')

nnoremap('<leader><leader>t', '<cmd>tabe %<CR>')
nnoremap('<leader><leader>T', '<C-W>T')

-- Quick jump to notes
vim.keymap.set('n', '<leader>n.', function() vim.cmd('e ~/Notes/Content') end)
vim.keymap.set('n', '<leader>nn', function() vim.cmd(os.date('e ~/Notes/Content/Daily/%Y-%m-%d.md')) end)

-- Insert date in insert mode
vim.keymap.set('i', '<C-d>', "<C-r>=strftime('%F')<CR>")
vim.keymap.set('i', '<C-M-d>', "<C-r>=strftime('%F: %a %b %-e, %Y')<CR>")
