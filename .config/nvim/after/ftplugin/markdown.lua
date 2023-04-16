local Path = require('plenary.path')



vim.keymap.set('n', 'gx', '<Plug>Markdown_FollowLink', { buffer = true })



------------------------
--- Preview image in feh
------------------------

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
  return source
end

local function open_image_in_feh()
  local source = find_absolute_link_under_cursour()
  if source == nil then
    print("No file found")
    return
  elseif not Path:new(source):exists() then
    print("File does not exist: "..source)
    return
  end
  vim.cmd("silent !preview-image '"..source.."'")
end

vim.keymap.set("n", "<leader>s", function() open_image_in_feh() end)

