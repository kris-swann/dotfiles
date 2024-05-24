-- Get visual selection by yanking into 'v' register (with autocmds disabled)
-- NOTE: overwrites existing 'v' register
local function get_visual_selection()
  vim.cmd('noau normal! "vy"')
  return vim.fn.getreg('v')
end

return get_visual_selection
