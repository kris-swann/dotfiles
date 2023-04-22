local set = vim.keymap.set

set('n', '<tab><enter>', function() require("harpoon.mark").add_file() end)

set('n', '<tab><tab>', function() require("harpoon.ui").toggle_quick_menu() end)

set('n', '<tab>j', function() require("harpoon.ui").nav_file(1) end)
set('n', '<tab>k', function() require("harpoon.ui").nav_file(2) end)
set('n', '<tab>l', function() require("harpoon.ui").nav_file(3) end)
set('n', '<tab>h', function() require("harpoon.ui").nav_file(4) end)

set('n', '<tab>o', function() require("harpoon.term").gotoTerminal(1) end)
