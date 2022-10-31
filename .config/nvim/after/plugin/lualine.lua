require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      {
        'diff',
        symbols = { added = ' ', modified = '柳 ', removed = ' ' },
      },
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        file_status = true,     -- Displays file status (readonly status, modified status)
        newfile_status = true,   -- Display new file status (new file means no write after created)
        path = 0,               -- Just the filename
        symbols = {
          modified = '[+]',
          readonly = '[RO]',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
      },
    },
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
