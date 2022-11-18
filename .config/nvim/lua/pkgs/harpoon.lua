local keymap = require('utils.keymap')
local nnoremap = keymap.nnoremap

nnoremap('<tab><enter>', function() require("harpoon.mark").add_file() end)

nnoremap('<tab><tab>', function() require("harpoon.ui").toggle_quick_menu() end)

nnoremap('<tab>j', function() require("harpoon.ui").nav_file(1) end)
nnoremap('<tab>k', function() require("harpoon.ui").nav_file(2) end)
nnoremap('<tab>l', function() require("harpoon.ui").nav_file(3) end)
nnoremap('<tab>h', function() require("harpoon.ui").nav_file(4) end)

nnoremap('<tab>o', function() require("harpoon.term").gotoTerminal(1) end)
