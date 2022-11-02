local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local ccc = require("ccc")
local mapping = ccc.mapping
local excludes = {
  'dirbuf',
}
ccc.setup({
  mappings = {
    ["b"] = mapping.decrease1,
    ["f"] = mapping.increase1,
  },
  highlighter = {
    auto_enable = true,
    excludes = excludes,
  },
})

-- For some reason, if the inital load should be captured by the 'excludes' above the highlighter
-- is still enabled. We manually disable that here too.
-- Bizzarly this is not an issue if this setup file is in after/plugin
--    i.e mv ./ccc.lua ../../after/plugin/ccs.lua
augroup('ccc-exclude', { clear = true })
autocmd({ 'FileType' }, {
  group = 'ccc-exclude',
  pattern = excludes,
  command = [[CccHighlighterDisable]],
})
