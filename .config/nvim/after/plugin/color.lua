vim.opt.background = 'dark'

if not require('utils.plugin_is_loaded')('tokyonight') then
  print("tokyonight is not installed")
  return
end

require('tokyonight').setup({
  style = 'storm',
  light_style = 'day',
  terminal_colors = true,  -- Colors when opening a :terminal
  day_brightness = 0.4, -- Brightness of colors in 'day' style. From 0 to 1, from dull to vibrant colors
  on_highlights = function(hl, c)
    hl.Folded = {  -- Folded line
      fg = "#7aa2f7",
      -- fg = "#4fd6be",
      style = {
        bold = true,
      }
    }
  end,
})
vim.cmd[[colorscheme tokyonight-moon]]
