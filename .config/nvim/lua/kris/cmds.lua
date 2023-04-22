local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

cmd('Notes', [[:e ~/Notes/Content]], {})
cmd('NN', function() vim.cmd(os.date('e ~/Notes/Content/Daily/%Y-%m-%d.md')) end, {})
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
