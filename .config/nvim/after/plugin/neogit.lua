local neogit = require('neogit')

neogit.setup({
  kind = 'split_above',
  integrations = {
    diffview = true,
  },
})
