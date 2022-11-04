local neogit = require('neogit')

neogit.setup({
  kind = 'tab',  -- tab | replace | floating | split | split_above | vsplit
  integrations = {
    diffview = true,
  },
})
