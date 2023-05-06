local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local Path = require('plenary.path')





--------------------------
-- Basic Markdown defaults
--------------------------
vim.cmd('IndentBlanklineDisable')

-- Hack: Must wrap opts in autocmd to play nice with oil.nvim
augroup("markdown-basic-opts", { clear = true })
autocmd({ "BufWinEnter" }, {
  group = "markdown-basic-opts",
  pattern = { "*.md" },
  callback = function ()
    vim.opt_local.textwidth = 70
    vim.opt_local.spell = true
  end,
})





----------------------------------------------
-- Folding (Obsidian style callouts)
----------------------------------------------
-- function NotesMarkdownCalloutFoldExpr(line_num)
--   local line = vim.fn.getline(line_num)
--   -- Fold level is the number of leading '>' chars (ignoring spaces)
--   local num_quotes = 0
--   for char in line:gmatch"." do
--     if char == ">" then
--       num_quotes = num_quotes + 1
--     elseif char ~= " " then
--       break
--     end
--   end
--   return num_quotes
-- end

-- function NotesMarkdownCalloutFoldText(foldstart)
--   local line = vim.fn.getline(foldstart)
--   -- Try to extract display title from `> [!info]-` style lines
--   local start, _, callout_type, callout_title = line:find("> %[!(.-)%]%-? ?(.*)")
--   local prefix = line:sub(0, start - 1)
--   if (callout_title:len() > 0) then
--     return prefix..callout_title
--   elseif (callout_type:len() > 0) then
--     -- Note, the surrounding parens are nessesary to return a string instead of a tuple
--     return prefix..(
--       callout_type
--       :gsub("%-", " ")            -- Replace `-` with ` `
--       :gsub("^%l", string.upper)  -- Capitalize first letter
--       :gsub(" %l", string.upper)  -- Capitalize first letter of rest of the words
--     )
--   else
--     return line
--   end
-- end


function MarkdownFoldText(foldstart)
  local line = vim.fn.getline(foldstart)
  return line..'...'
end

-- Hack: Must wrap opts in autocmd to play nice with oil.nvim
augroup("notes-set-fold", { clear = true })
autocmd({ "BufWinEnter" }, {
  group = "notes-set-fold",
  pattern = { "*.md" },
  callback = function ()
    -- TODO: remove this once decided on a method
    -- vim.opt_local.foldmethod = "expr"
    -- vim.opt_local.foldexpr = "v:lua.NotesMarkdownCalloutFoldExpr(v:lnum)"
    -- vim.opt_local.foldtext = "v:lua.NotesMarkdownCalloutFoldText(v:foldstart)"

    -- NOTE: Using custom fold expr instead of treesitter because tresitter foldexpr
    -- doesn't always set h3 to fold level 3
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr="NestedMarkdownFolds()"  -- Comes from masukomi/vim-markdown-folding
    vim.opt_local.foldtext = "v:lua.MarkdownFoldText(v:foldstart)"
    vim.opt_local.foldlevel = 2  -- Fold h3's and lower on open
  end,
})

-- -- For some reason fold level isn't recomputed on newly inserted text
-- -- resetting the foldmethod does that without messing up the foldlevel
-- augroup("notes-recompute-folds", { clear = true })
-- autocmd({ "InsertLeave", "TextChanged" }, {
--   group = "notes-recompute-folds",
--   pattern = { "*.md" },
--   callback = function ()
--     vim.opt_local.foldmethod = "expr"
--   end,
-- })






------------------------------
-- Smart gx
------------------------------

-- Copied from ixru/nvim-markdown
local function find_word_under_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local mode = vim.fn.mode(".")
  if mode:find("n") then
    -- normal mode is converted to 1 index while insert mode is
    -- left as 0 index, this is because of how spaces are counted
    cursor[2] = cursor[2] + 1
  end
  local line = vim.fn.getline(cursor[1])
  local word_start, word_stop, word
  local start = 1
  repeat
    -- repeats until it finds a link the cursor is inside or ends as nil
    word_start, word_stop, word = line:find("([^%s]+)", start)
    if word_start then
      start = word_stop + 1
    end
  until not word_start or (word_start <= cursor[2] and word_stop >= cursor[2])
  if word_start then
    return {
      start = word_start,
      stop = word_stop,
      text = word,
    }
  else
    return nil
  end
end

-- Modified from ixru/nvim-markdown
local function find_link_under_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.fn.getline(cursor[1])
  local column = cursor[2] + 1
  local link_start, link_stop, link
  local start = 1
  repeat
    -- repeats until it finds a link the cursor is inside or ends as nil
    link_start, link_stop, image_marker, text, url = line:find("(!?)%[(.-)%]%((.-)%)", start)
    if link_start then
        start = link_stop + 1
    end
  until not link_start or (link_start <= column and link_stop >= column)
  if link_start then
    return {
      link = "[" .. text .. "](" .. url .. ")",
      start = link_start,
      stop = link_stop,
      is_image = image_marker == '!',
      text = text,
      url = url
    }
  else
    return nil
  end
end

local function link_url_to_absolute_path(url)
  local buf_dir = vim.fn.expand('%:p:h')
  local source = url
  if not Path:new(source):is_absolute() then
    source = Path:new({ buf_dir, url }):absolute()
  end
  return source
end

local function open_image_in_feh(path)
  if path == nil then
    print("No file found")
    return
  elseif not Path:new(path):exists() then
    print("File does not exist: "..path)
    return
  end
  vim.cmd("silent !preview-image '"..path.."'")
end

-- Modified from ixru/nvim-markdown
local function smart_open()
  local word = find_word_under_cursor()
  local link = find_link_under_cursor()
  if link and link.url then
    if link.is_image then
      open_image_in_feh(link_url_to_absolute_path(link.url))
    elseif link.url:match("^https?://") then
      vim.call("netrw#BrowseX", link.url, 0)  -- a url
    elseif link.url:match("^#") then
      vim.fn.search("^#* "..link.url:sub(2))  -- an anchor
    else
      vim.cmd("e " .. link.url)  -- a file
    end
  elseif word then
    if word.text:match("^https?://") then
      -- Bare url i.e without link syntax
      vim.call("netrw#BrowseX", word.text, 0)
    else
      -- create a link
      local filename = string.lower(word.text:gsub("%s","_") .. ".md")
      vim.cmd('norm! "_ciW[' .. word.text .. '](' .. filename ..')')
    end
  end
end

vim.keymap.set("n", "gx", function() smart_open() end)
