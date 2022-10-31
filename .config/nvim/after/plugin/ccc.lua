local ccc = require("ccc")
local mapping = ccc.mapping
ccc.setup({
  mappings = {
    ["b"] = mapping.decrease1,
    ["f"] = mapping.increase1,
  },
  highlighter = {
    auto_enable = true,
    excludes = {
      'dirbuf'
    }
  },
})
