-- local set = require('utils.keymap').set

require("obsidian").setup({
  dir = "~/Notes",
  disable_frontmatter = true,
  completion = {
    -- nvim_cmp = true,
  },
  daily_notes = {
    folder = "Text/Daily",
  },
})

-- Map gf to :ObsidianFollowLink
-- set({ 'n' }, 'gf',
--   function()
--     if require('obsidian').util.cursor_on_markdown_link() then
--       return "<cmd>ObsidianFollowLink<CR>"
--     else
--       return "gf"
--     end
--   end,
--   { noremap = false, expr = true }
-- )
