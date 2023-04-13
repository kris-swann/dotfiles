local awful = require("awful")
local sharedtags = require("external.awesome-sharedtags")

local default_layout = awful.layout.layouts[1]

return sharedtags({
  { name = "`", layout = default_layout },
  { name = "1", layout = default_layout },
  { name = "2", layout = default_layout },
  { name = "3", layout = default_layout },
  { name = "4", layout = default_layout },
  { name = "5", layout = default_layout },
  { name = "6", layout = default_layout },
  { name = "7", layout = default_layout },
  { name = "8", layout = default_layout },
  { name = "9", layout = default_layout },
  { name = "0", layout = default_layout },
})
