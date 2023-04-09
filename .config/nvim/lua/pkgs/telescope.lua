local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local extensions = telescope.extensions

local nnoremap = require('utils.keymap').nnoremap
local cmd = vim.api.nvim_create_user_command

telescope.setup({
  extensions = {
    emoji = {
      action = function(emoji)
        vim.api.nvim_put({ emoji.value }, 'c', false, true)  -- Insert when picked
      end,
    }
  },
})

telescope.load_extension('fzf')
telescope.load_extension('emoji')
telescope.load_extension('find_pickers')
telescope.load_extension("yank_history")

-- File pickers
nnoremap(',f', builtin.find_files)
nnoremap(',,c', function() builtin.find_files({ cwd = '~/.config/nvim/' }) end)
nnoremap(',,n', function() builtin.find_files({ cwd = '~/Notes' }) end)
nnoremap(',,s', function() builtin.find_files({ cwd = '~/Scripts' }) end)
nnoremap(',,/', function() builtin.find_files({ cwd = '~/.config/' }) end)

-- Grep pickers
nnoremap(',/', builtin.live_grep)
cmd('Rg', function(props) builtin.grep_string({ search = props.args }) end, { nargs = '*' })

-- Text pickers
nnoremap('z=', builtin.spell_suggest)
nnoremap(',e', extensions.emoji.emoji)
nnoremap(',p', function() extensions.yank_history.yank_history({}) end)

-- Vim pickers
nnoremap('&b', builtin.buffers)
nnoremap('&m', builtin.marks)
nnoremap('&q', builtin.quickfix)
nnoremap('&l', builtin.loclist)
nnoremap('&j', builtin.jumplist)
nnoremap('&r', builtin.registers)
nnoremap('&k', builtin.keymaps)
nnoremap('&c', builtin.commands)
nnoremap('&p', extensions.find_pickers.find_pickers)
nnoremap('&h', builtin.help_tags)
nnoremap('&/', builtin.search_history)
nnoremap('&:', builtin.command_history)

-- Git pickers
nnoremap(',gf', builtin.git_files)
nnoremap(',gc', builtin.git_commits)
nnoremap(',gh', builtin.git_bcommits)
nnoremap(',gb', builtin.git_branches)
nnoremap(',gs', builtin.git_status)
nnoremap(',gt', builtin.git_stash)

-- Lsp pickers
nnoremap('<ctrl-]>', builtin.lsp_definitions)
nnoremap('gd', builtin.lsp_definitions)
nnoremap('gD', builtin.lsp_type_definitions)
nnoremap(',r', builtin.lsp_references)
-- TODO move these to a parent picker?
-- nnoremap(',i', function() builtin.lsp_implementations() end)
-- nnoremap(',ci', function() builtin.lsp_incoming_calls() end)
-- nnoremap(',co', function() builtin.lsp_outgoing_calls() end)
nnoremap(',dd', function() builtin.diagnostics({ bufnr = 0 }) end)  -- bufnr = 0 for cur buf
nnoremap(',da', builtin.diagnostics)
