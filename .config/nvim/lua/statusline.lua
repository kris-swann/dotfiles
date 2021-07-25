local devicons = require'nvim-web-devicons'
local Job = require'plenary.job'
local c = require'onedark.colors'

local mode_map = {
  ['n']    = { key = 'NORMAL',    display = 'N' },
  ['no']   = { key = 'O-PENDING', display = 'O-PENDING' },
  ['nov']  = { key = 'O-PENDING', display = 'O-PENDING' },
  ['noV']  = { key = 'O-PENDING', display = 'O-PENDING' },
  ['no'] = { key = 'O-PENDING', display = 'O-PENDING' },
  ['niI']  = { key = 'NORMAL',    display = 'N' },
  ['niR']  = { key = 'NORMAL',    display = 'N' },
  ['niV']  = { key = 'NORMAL',    display = 'N' },
  ['v']    = { key = 'VISUAL',    display = 'V' },
  ['V']    = { key = 'VISUAL',    display = 'V-LINE' },
  ['']   = { key = 'VISUAL',    display = 'V-BLOCK' },
  ['s']    = { key = 'SELECT',    display = 'S' },
  ['S']    = { key = 'SELECT',    display = 'S-LINE' },
  ['']   = { key = 'SELECT',    display = 'S-BLOCK' },
  ['i']    = { key = 'INSERT',    display = 'I' },
  ['ic']   = { key = 'INSERT',    display = 'I' },
  ['ix']   = { key = 'INSERT',    display = 'I' },
  ['R']    = { key = 'REPLACE',   display = 'R' },
  ['Rc']   = { key = 'REPLACE',   display = 'R' },
  ['Rv']   = { key = 'REPLACE',   display = 'V-R' },
  ['Rx']   = { key = 'REPLACE',   display = 'R' },
  ['c']    = { key = 'COMMAND',   display = 'C' },
  ['cv']   = { key = 'EX',        display = 'EX' },
  ['ce']   = { key = 'EX',        display = 'EX' },
  ['r']    = { key = 'REPLACE',   display = 'R' },
  ['rm']   = { key = 'MORE',      display = 'MORE' },
  ['r?']   = { key = 'CONFIRM',   display = 'CONFIRM' },
  ['!']    = { key = 'SHELL',     display = 'SHELL' },
  ['t']    = { key = 'TERM',      display = 'T' },
}

function get_mode()
  local code = vim.fn.mode()
  return mode_map[code] or { key = 'DEFAULT', display = code }
end

function get_hlcolors(hlname)
  -- Given name of a hlgroup return { fg = '#xxxxxx', bg = '#xxxxxx' } or nil
  local ok, color = pcall(vim.api.nvim_get_hl_by_name, hlname, true)
  if not ok or color == nil then return nil end
  color.bg = color.background ~= nil and string.format('#%06x', color.background) or nil
  color.background = nil
  color.fg = color.foreground ~= nil and string.format('#%06x', color.foreground) or nil
  color.foreground = nil
  return color
end

function hl(group_name, str) return '%#' .. group_name .. '#' .. str end

function get_filetype(bufnr, hlname)
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

function get_branch(bufnr)
  local buf_dir = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':h')
  local j = Job:new({
    command = "git", args = {"branch", "--show-current"}, cwd = buf_dir,
  })
  local ok, result = pcall(function() return vim.trim(j:sync()[1]) end)
  if ok then
    return result
  end
end

function get_diagnostics()
  local ok, data = pcall(vim.fn['ale#statusline#Count'], vim.fn.bufnr())
  if ok then return data.error, data.warning, data.info end
  return 0, 0, 0
end

function stl_diagnostics(hlprefix)
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

function statusline_colors(mode, active)
  local default = {
    base = { fg = c.fg, bg = c.bg1 },
    accent = { fg = c.fg, bg = c.bg_d },
    secondary = { fg = c.fg, bg = c.bg3 },
    err = c.dark_red,
    warn = c.dark_yellow,
    info = c.dark_cyan,
  }
  local by_mode = {
    NORMAL = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = '#A12060' },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
    VISUAL = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = c.dark_yellow },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
    INSERT = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = c.dark_purple },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
    REPLACE = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = c.dark_red },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
    COMMAND = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = c.dark_cyan },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
    TERM = {
      base = { fg = c.fg, bg = c.bg1 },
      accent = { fg = c.fg, bg = '#478735' },
      secondary = { fg = c.fg, bg = c.bg3 },
      err = c.dark_red,
      warn = c.dark_yellow,
      info = c.dark_cyan,
    },
  }
  if not active then return default end
  return by_mode[mode.key] or default
end

function update_highlight_groups(hlprefix, colors)
  vim.cmd('highlight ' .. hlprefix .. 'Base guifg=' .. colors.base.fg .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight ' .. hlprefix .. 'BaseErr guifg=' .. colors.err .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight ' .. hlprefix .. 'BaseWarn guifg=' .. colors.warn .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight ' .. hlprefix .. 'BaseInfo guifg=' .. colors.info .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight ' .. hlprefix .. 'Accent guifg=' .. colors.accent.fg .. ' guibg=' .. colors.accent.bg)
  vim.cmd('highlight ' .. hlprefix .. 'Secondary guifg=' .. colors.secondary.fg .. ' guibg=' .. colors.secondary.bg)
  vim.cmd('highlight ' .. hlprefix .. 'AccentSecondarySep guifg=' .. colors.accent.bg .. ' guibg=' .. colors.secondary.bg)
  vim.cmd('highlight ' .. hlprefix .. 'AccentBaseSep guifg=' .. colors.accent.bg .. ' guibg=' .. colors.base.bg)
  vim.cmd('highlight ' .. hlprefix .. 'SecondaryBaseSep guifg=' .. colors.secondary.bg .. ' guibg=' .. colors.base.bg)
end

-- TODO Trailing whitespace/mixed indent
--    search for trailing whitespace: [ \t]\+$
-- TODO git merge conflict warnings
-- TODO crypt/spell/paste/insert ??
-- TODO show num words / lines in visual modes only (w/ clipboard or selction icon)
-- TODO vimagit integration?
-- TODO anything else from airline/vimline/powerline that would be nice?
function make_statusline()
  local winid = vim.g.statusline_winid
  local bufnr = vim.fn.winbufnr(winid)
  local active_winid = vim.fn.win_getid()
  local active = winid == active_winid
  local mode = get_mode()
  local hlprefix = active and 'Stl' .. mode.key or 'StlInactive'
  local colors = statusline_colors(mode, active)
  update_highlight_groups(hlprefix, colors)

  local rsep = ''
  local lsep = ''
  local spacer = '%='
  local filename = '%t'
  local progress = '%p%%'
  local position = '%l:%-2c %L☰'
  local filetype = get_filetype(bufnr, hlprefix .. 'Base')
  local branch_name = get_branch(bufnr)
  local branch_text = ''
  if branch_name then branch_text = '  ' .. branch_name end
  if #branch_text > 15 then
    branch_text = string.sub(branch_text, 1, 15) .. '..'
  end
  local diagnostic_text = stl_diagnostics(hlprefix .. 'Base')

  if not active then
    return hl(hlprefix .. 'Base', ' ' .. filename .. spacer .. position .. ' ')
  end

  return (
    hl(hlprefix .. 'Accent', ' ' .. mode.display .. ' ')
    .. hl(hlprefix .. 'AccentSecondarySep', rsep)
    .. hl(hlprefix .. 'Secondary', branch_text)
    .. hl(hlprefix .. 'SecondaryBaseSep', rsep)
    .. hl(hlprefix .. 'Base', ' ' .. filename .. spacer .. diagnostic_text .. filetype .. ' ')
    .. hl(hlprefix .. 'SecondaryBaseSep', lsep)
    .. hl(hlprefix .. 'Secondary', ' ' .. progress .. ' ')
    .. hl(hlprefix .. 'AccentSecondarySep', lsep)
    .. hl(hlprefix .. 'Accent', ' ' .. position .. ' ')
  )
end

return {
  make_statusline = make_statusline
}
