local telescope = require('telescope')
local builtin = require('telescope.builtin')

local nnoremap = require('util.keymap').nnoremap
local cmd = vim.api.nvim_create_user_command

telescope.setup({
  extensions = {
    emoji = {
      action = function(emoji)
        -- argument emoji is a table.
        -- {name="", value="", cagegory="", description=""}
        -- vim.fn.setreg("*", emoji.value)  -- Default behavior is to copy into the * register
        -- print([[Press p or "*p to paste this emoji]] .. emoji.value)
        vim.api.nvim_put({ emoji.value }, 'c', false, true)  -- Insert when picked
      end,
    }
  },
})

telescope.load_extension('fzf')
telescope.load_extension('emoji')

-- File pickers
nnoremap(',f', function() builtin.find_files() end)
nnoremap(',g', function() builtin.git_files() end)
nnoremap(',/', function() builtin.live_grep() end)

-- Vim pickers
nnoremap(',ls', function() builtin.buffers() end)
nnoremap(',m', function() builtin.marks() end)
nnoremap(',q', function() builtin.quickfix() end)
nnoremap(',l', function() builtin.loclist() end)
nnoremap(',j', function() builtin.jumplist() end)
nnoremap(',r', function() builtin.registers() end)
nnoremap(',hh', function() builtin.help_tags() end)
nnoremap(',hk', function() builtin.keymaps() end)
nnoremap(',hc', function() builtin.commands() end)
nnoremap('z=', function() builtin.spell_suggest() end)
nnoremap(',c', function() builtin.find_files({ cwd = '~/.config/nvim/' }) end)
nnoremap(',e', ':Telescope emoji<CR>')

-- Git pickers
nnoremap(',gc', function() builtin.git_commits() end)
nnoremap(',gf', function() builtin.git_bcommits() end)
nnoremap(',gb', function() builtin.git_branches() end)
nnoremap(',gs', function() builtin.git_status() end)
nnoremap(',gt', function() builtin.git_stash() end)

-- Lsp pickers
nnoremap(',d', function() builtin.lsp_definitions() end)
nnoremap(',D', function() builtin.lsp_type_definitions() end)
nnoremap(',r', function() builtin.lsp_references() end)
-- TODO move these to a parent picker
-- nnoremap(',i', function() builtin.lsp_implementations() end)
-- nnoremap(',ci', function() builtin.lsp_incoming_calls() end)
-- nnoremap(',co', function() builtin.lsp_outgoing_calls() end)
nnoremap(',le', function() builtin.diagnostics({ bufnr = 0 }) end)  -- bufnr = 0 for cur buf
nnoremap(',we', function() builtin.diagnostics() end)  -- all buffers
