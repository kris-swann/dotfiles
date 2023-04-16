local Path = require('plenary.path')

require("hologram").setup({
  auto_display = false -- WIP automatic markdown image display, may be prone to breaking
})


vim.api.nvim_buf_call(0, function ()

end)


-- Copied from ixru/nvim-markdown
local function find_link_under_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.fn.getline(cursor[1])
  local column = cursor[2] + 1
  local link_start, link_stop, link
  local start = 1
  repeat
    -- repeats until it finds a link the cursor is inside or ends as nil
    link_start, link_stop, text, url = line:find("!%[(.-)%]%((.-)%)", start)
    if link_start then
        start = link_stop + 1
    end
  until not link_start or (link_start <= column and link_stop >= column)


  if link_start then
    return {
      link = "[" .. text .. "](" .. url .. ")",
      start = link_start,
      stop = link_stop,
      text = text,
      url = url
    }
  else
    return nil
  end
end

local function find_absolute_link_under_cursour()
  local link = find_link_under_cursor()
  if link == nil then
    return nil
  end
  local buf_dir = vim.fn.expand('%:p:h')
  local source = link.url
  if not Path:new(source):is_absolute() then
    source = Path:new({ buf_dir, link.url }):absolute()
  end
  if not Path:new(source):exists() then
    return nil
  end
  return source
end




local function show_image()
  local link = find_link_under_cursor()
  if link == nil then
    return nil
  end
  local source_raw = link.url
  local buf_dir = vim.fn.expand('%:p:h')

  local source = link.url
  if not Path:new(source):is_absolute() then
    source = Path:new({ buf_dir, link.url }):absolute()
  end

  if not Path:new(source):exists() then
    print("path does not exist")
    return
  end

  local image = require("hologram.image"):new(source, {})

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { source_raw, buf_dir, source })
  local opts = {
    relative = "editor",
    anchor = 'NW',
    width = 100,
    height = 50,
    col = 0,
    row = 1,
    style = "minimal",
    border = "shadow",
  }
  local win = vim.api.nvim_open_win(buf, true, opts)

  image:display(3, 0, buf, {})
  vim.defer_fn(function()
      image:delete(0, {free = true})
  end, 5000)


  -- optional: change highlight, otherwise Pmenu is used
  -- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
end


vim.keymap.set("n", "<leader>s", function() show_image() end)



-- local function show_image_old()
--   local source = get_selection()
--   local buf = vim.api.nvim_get_current_buf()
--   local image = require("hologram.image"):new(source, {})
--   image:display(5, 0, buf, {})
--   vim.defer_fn(function()
--       image:delete(0, {free = true})
--   end, 5000)
-- end
