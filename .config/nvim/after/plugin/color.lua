require('tokyonight').setup({
  style = 'storm',
  light_style = 'day',
  terminal_colors = true,  -- Colors when opening a :terminal
  day_brightness = 0.4, -- Brightness of colors in 'day' style. From 0 to 1, from dull to vibrant colors
})

vim.opt.background = 'dark'
vim.cmd[[colorscheme tokyonight-moon]]
