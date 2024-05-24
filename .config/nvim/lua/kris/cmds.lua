local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local rebuild_spellfiles = require('utils.rebuild_spellfiles')

cmd('Notes', [[:e ~/Notes]], { desc = 'Open Notes dir' })

cmd('No', [[:Notes]], { desc = 'Open Notes dir' })
cmd('NO', [[:Notes]], { desc = 'Open Notes dir' })

cmd('Config', [[:e ~/.config/nvim]], { desc = 'Open nvim config dir' })
cmd('Sxhkdrc', [[:e ~/.config/sxhkd/sxhkdrc]], { desc = 'Open sxhkd config file' })

autocmd({ 'BufWritePost' }, {
  desc = 'Refresh sxhkd bindings whenever bindings file is written',
  group = augroup('sxhkd-refresh', { clear = true }),
  pattern = { '*sxhkdrc' },
  command = [[!pkill -USR1 sxhkd]],
})

cmd('RebuildSpellfiles', rebuild_spellfiles, {})
autocmd({ 'VimEnter', 'FocusGained' }, {
  desc = 'Automatically rebuild Spellfiles on startup or tabswitch',
  group = augroup('auto-rebuild-spellfiles', { clear = true }),
  callback = rebuild_spellfiles,
})

-- autocmd({ 'TextYankPost' }, {
--   desc = 'Highlight yanked text',
--   group = augroup('highlight-yanked-text', { clear = true }),
--   callback = function() vim.highlight.on_yank() end,
-- })
