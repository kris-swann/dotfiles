local telescope = require('telescope')
local builtin = require('telescope.builtin')
local extensions = telescope.extensions

local cmd = vim.api.nvim_create_user_command
local set = vim.keymap.set

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
set('n', ',f', builtin.find_files)
set('n', ',,c', function() builtin.find_files({ cwd = '~/.config/nvim/' }) end)
set('n', ',,n', function() builtin.find_files({ cwd = '~/Notes' }) end)
set('n', ',,s', function() builtin.find_files({ cwd = '~/Scripts' }) end)
set('n', ',,/', function() builtin.find_files({ cwd = '~/.config/' }) end)

-- Grep pickers
set('n', ',/', builtin.live_grep)
cmd(
  'Rg',
  function(props)
    builtin.grep_string({
      search = props.args,
      use_regex = true
    })
  end,
  { nargs = '*' }
)

-- Text pickers
set('n', 'z=', builtin.spell_suggest)
set('n', ',e', extensions.emoji.emoji)
set('n', ',p', function() extensions.yank_history.yank_history({}) end)

-- Vim pickers
set('n', '&b', builtin.buffers)
set('n', '&m', builtin.marks)
set('n', '&q', builtin.quickfix)
set('n', '&l', builtin.loclist)
set('n', '&j', builtin.jumplist)
set('n', '&r', builtin.registers)
set('n', '&k', builtin.keymaps)
set('n', '&c', builtin.commands)
set('n', '&p', extensions.find_pickers.find_pickers)
set('n', '&h', builtin.help_tags)
set('n', '&/', builtin.search_history)
set('n', '&:', builtin.command_history)

-- Git pickers
set('n', ',gf', builtin.git_status)
set('n', ',gc', builtin.git_commits)
set('n', ',gh', builtin.git_bcommits)
set('n', ',gb', builtin.git_branches)
set('n', ',ga', builtin.git_files)
set('n', ',gt', builtin.git_stash)

-- Lsp pickers
set('n', '<ctrl-]>', builtin.lsp_definitions)
set('n', 'gd', builtin.lsp_definitions)
set('n', 'gD', builtin.lsp_type_definitions)
set('n', ',r', builtin.lsp_references)
-- TODO move these to a parent picker?
-- set('n', ',i', function() builtin.lsp_implementations() end)
-- set('n', ',ci', function() builtin.lsp_incoming_calls() end)
-- set('n', ',co', function() builtin.lsp_outgoing_calls() end)
set('n', ',dd', function() builtin.diagnostics({ bufnr = 0 }) end)  -- bufnr = 0 for cur buf
set('n', ',da', builtin.diagnostics)
