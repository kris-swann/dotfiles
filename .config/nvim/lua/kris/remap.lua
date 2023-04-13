local noremap = require('utils.keymap').noremap
local nnoremap = require('utils.keymap').nnoremap
local tnoremap = require('utils.keymap').tnoremap

-- Prefer virtual replace over normal replace (plays nicer w/ tabs and eols)
nnoremap('R', 'gR')

-- Disable Ex Mode
nnoremap('Q', '<Nop>')
nnoremap('gQ', '<Nop>')

-- Same movement in wrapped lines
nnoremap('j', 'gj')
nnoremap('k', 'gk')

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
