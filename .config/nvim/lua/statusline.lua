local devicons = require'nvim-web-devicons'
local Job = require'plenary.job'
local c = require'onedark.colors'

local mode_map = {
  ['n']    = { key = 'Normal',  display = 'N' },
  ['no']   = { key = 'Default', display = 'O-PENDING' },
  ['nov']  = { key = 'Default', display = 'O-PENDING' },
  ['noV']  = { key = 'Default', display = 'O-PENDING' },
  ['no'] = { key = 'Default', display = 'O-PENDING' },
  ['niI']  = { key = 'Normal',  display = 'N' },
  ['niR']  = { key = 'Normal',  display = 'N' },
  ['niV']  = { key = 'Normal',  display = 'N' },
  ['v']    = { key = 'Visual',  display = 'V' },
  ['V']    = { key = 'Visual',  display = 'V-LINE' },
  ['']   = { key = 'Visual',  display = 'V-BLOCK' },
  ['s']    = { key = 'Select',  display = 'S' },
  ['S']    = { key = 'Select',  display = 'S-LINE' },
  ['']   = { key = 'Select',  display = 'S-BLOCK' },
  ['i']    = { key = 'Insert',  display = 'I' },
  ['ic']   = { key = 'Insert',  display = 'I' },
  ['ix']   = { key = 'Insert',  display = 'I' },
  ['R']    = { key = 'Replace', display = 'R' },
  ['Rc']   = { key = 'Replace', display = 'R' },
  ['Rv']   = { key = 'Replace', display = 'V-R' },
  ['Rx']   = { key = 'Replace', display = 'R' },
  ['c']    = { key = 'Command', display = 'C' },
  ['cv']   = { key = 'Default', display = 'EX' },
  ['ce']   = { key = 'Default', display = 'EX' },
  ['r']    = { key = 'Replace', display = 'R' },
  ['rm']   = { key = 'Default', display = 'MORE' },
  ['r?']   = { key = 'Default', display = 'CONFIRM' },
  ['!']    = { key = 'Default', display = 'SHELL' },
  ['t']    = { key = 'Term',    display = 'T' },
}

local function get_mode()
  local code = vim.fn.mode()
  return mode_map[code] or { key = 'DEFAULT', display = code }
end

local function get_hlcolors(hlname)
  -- Given name of a hlgroup return { fg = '#xxxxxx', bg = '#xxxxxx' } or nil
  local ok, color = pcall(vim.api.nvim_get_hl_by_name, hlname, true)
  if not ok or color == nil then return nil end
  color.bg = color.background ~= nil and string.format('#%06x', color.background) or nil
  color.background = nil
  color.fg = color.foreground ~= nil and string.format('#%06x', color.foreground) or nil
  color.foreground = nil
  return color
end

local function hl(group_name, str) return '%#' .. group_name .. '#' .. str end

local function get_filetype(bufnr, hlname)
  local base_hlcolors = get_hlcolors(hlname)
  local full_file_name = vim.api.nvim_buf_get_name(bufnr)
  local f_name = string.match(full_file_name, '[^/]+$')
  local f_extension = string.match(full_file_name, '[^.]+$')
  local icon, icon_hlname = devicons.get_icon(f_name, f_extension)
  local icon_hlcolors = get_hlcolors(icon_hlname)
  local filetype = vim.bo[bufnr].filetype
  if icon == nil then
    return filetype
  elseif icon_hlcolors == nil then
    return icon .. ' ' .. filetype
  else
    local stl_icon_hlname = hlname .. icon_hlname
    vim.cmd(
      'highlight ' .. stl_icon_hlname
      .. ' guifg=' .. (icon_hlcolors.fg or 'NONE')
      .. ' guibg=' .. (base_hlcolors.bg or 'NONE')
    )
    return hl(stl_icon_hlname, icon) .. hl(hlname, ' ' .. filetype)
  end
end

local function get_branch(bufnr)
  local buf_dir = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':h')
  local j = Job:new({
    command = "git", args = {"branch", "--show-current"}, cwd = buf_dir,
  })
  local ok, result = pcall(function() return vim.trim(j:sync()[1]) end)
  if ok then
    return result
  end
end

local function get_diagnostics()
  local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
  if ok then return data.error, data.warning, data.info end
  return 0, 0, 0
end

local function stl_diagnostics(hlprefix)
  local err_count, warn_count, info_count = get_diagnostics()
  local err_symbol, warn_symbol, info_symbol = ' ', ' ', ' '
  stl_str = ''
  if err_count > 0 then
    stl_str = stl_str .. hl(hlprefix .. 'Err', err_symbol .. err_count .. ' ')
  end
  if warn_count > 0 then
    stl_str = stl_str .. hl(hlprefix .. 'Warn', warn_symbol .. warn_count .. ' ')
  end
  if info_count > 0 then
    stl_str = stl_str .. hl(hlprefix .. 'Info', info_symbol .. info_count .. ' ')
  end
  return stl_str
end

local stl_colors = {
  accent = {
    Normal = { fg = c.fg, bg = '#A12060' },
    Visual = { fg = c.fg, bg = c.dark_yellow },
    Insert = { fg = c.fg, bg = c.dark_purple },
    Replace = { fg = c.fg, bg = c.dark_red },
    Command = { fg = c.fg, bg = c.dark_cyan },
    Term = { fg = c.fg, bg = '#478735' },
    Default = { fg = c.fg, bg = c.bg_d },
  },
  base = {
    reg = { fg = c.fg, bg = c.bg1 },
    modified = { fg = c.fg, bg = '#431a68' },
  },
  secondary = { fg = c.fg, bg = c.bg3 },
  err = c.dark_red,
  warn = c.dark_yellow,
  info = c.dark_cyan,
}

local function update_highlight_groups()
  vim.cmd('highlight StlBase guifg=' .. stl_colors.base.reg.fg .. ' guibg=' .. stl_colors.base.reg.bg)
  vim.cmd('highlight StlBaseErr guifg=' .. stl_colors.err .. ' guibg=' .. stl_colors.base.reg.bg)
  vim.cmd('highlight StlBaseWarn guifg=' .. stl_colors.warn .. ' guibg=' .. stl_colors.base.reg.bg)
  vim.cmd('highlight StlBaseInfo guifg=' .. stl_colors.info .. ' guibg=' .. stl_colors.base.reg.bg)
  vim.cmd('highlight StlBaseSecondarySep guifg=' .. stl_colors.secondary.bg .. ' guibg=' .. stl_colors.base.reg.bg)

  vim.cmd('highlight StlBaseModified guifg=' .. stl_colors.base.modified.fg .. ' guibg=' .. stl_colors.base.modified.bg)
  vim.cmd('highlight StlBaseModifiedErr guifg=' .. stl_colors.err .. ' guibg=' .. stl_colors.base.modified.bg)
  vim.cmd('highlight StlBaseModifiedWarn guifg=' .. stl_colors.warn .. ' guibg=' .. stl_colors.base.modified.bg)
  vim.cmd('highlight StlBaseModifiedInfo guifg=' .. stl_colors.info .. ' guibg=' .. stl_colors.base.modified.bg)
  vim.cmd('highlight StlBaseModifiedSecondarySep guifg=' .. stl_colors.secondary.bg .. ' guibg=' .. stl_colors.base.modified.bg)

  vim.cmd('highlight StlSecondary guifg=' .. stl_colors.secondary.fg .. ' guibg=' .. stl_colors.secondary.bg)

  for key, accent in pairs(stl_colors.accent) do
    vim.cmd('highlight StlAccent' .. key .. ' guifg=' .. accent.fg .. ' guibg=' .. accent.bg)
    vim.cmd('highlight StlAccent' .. key .. 'SecondarySep guifg=' .. accent.bg .. ' guibg=' .. stl_colors.secondary.bg)
  end
end

-- TODO Trailing whitespace/mixed indent
--    search for trailing whitespace: [ \t]\+$
-- TODO git merge conflict warnings
-- TODO crypt/spell/paste/insert ??
-- TODO show num words / lines in visual modes only (w/ clipboard or selction icon)
-- TODO vimagit integration?
-- TODO anything else from airline/vimline/powerline that would be nice?
local function make_statusline()
  update_highlight_groups()
  local winid = vim.g.statusline_winid
  local bufnr = vim.fn.winbufnr(winid)
  local active_winid = vim.fn.win_getid()
  local active = winid == active_winid
  local modified = vim.bo[bufnr].modified
  local mode = get_mode()

  local base_hlname = modified and 'StlBaseModified' or 'StlBase'
  local accent_hlname = 'StlAccent' .. mode.key

  local rsep = ''
  local lsep = ''
  local spacer = '%='
  local filename = '%t'
  local progress = '%p%%'
  local position = '%l:%-2c %L☰'
  local filetype = get_filetype(bufnr, base_hlname)
  local branch_name = get_branch(bufnr)
  local branch_text = ''
  if branch_name then branch_text = '  ' .. branch_name end
  if #branch_text > 15 then
    branch_text = string.sub(branch_text, 1, 15) .. '..'
  end
  local diagnostic_text = stl_diagnostics(base_hlname)

  if not active then
    return hl(base_hlname, ' ' .. filename .. spacer .. position .. ' ')
  end

  return (
    hl(accent_hlname, ' ' .. mode.display .. ' ')
    .. hl(accent_hlname .. 'SecondarySep', rsep)
    .. hl('StlSecondary', branch_text)
    .. hl(base_hlname .. 'SecondarySep', rsep)
    .. hl(base_hlname, ' ' .. filename .. spacer .. diagnostic_text .. filetype .. ' ')
    .. hl(base_hlname .. 'SecondarySep', lsep)
    .. hl('StlSecondary', ' ' .. progress .. ' ')
    .. hl(accent_hlname .. 'SecondarySep', lsep)
    .. hl(accent_hlname, ' ' .. position .. ' ')
  )
end

return {
  make_statusline = make_statusline
}
