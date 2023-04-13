local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

cmd('Notes', [[:e ~/Notes]], {})
cmd('Config', [[:e ~/.config/nvim]], {})
cmd('Sxhkdrc', [[:e ~/.config/sxhkd/sxhkdrc]], {})

cmd('Jsbeautify', [[:!js-beautify % -r]], {})
cmd('Prettier', [[:!prettier % -w]], {})
cmd('Shfmt', [[:!shfmt -i 2 -w -s %]], {})
cmd('Gofmt', [[:!gofmt -w %]], {})

augroup('sxhkd-refresh', { clear = true })
autocmd({ 'BufWritePost' }, {
  group = 'sxhkd-refresh',
  pattern = { '*sxhkdrc' },
  command = [[!pkill -USR1 sxhkd]],
})

-- I tried to put this in after/ftplugin/markdown.lua but it wasn't working so doing here instead
augroup('autoset-spell', { clear = true })
autocmd({ 'BufWinEnter' }, {
  group = 'autoset-spell',
  pattern = { '*.md' },
  callback = function ()
    vim.opt_local.wrap = false
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 70
  end,
})
