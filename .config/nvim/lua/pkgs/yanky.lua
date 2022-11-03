local utils = require('yanky.utils')
local mapping = require('yanky.telescope.mapping')
local set = require('utils.keymap').set
local nmap = require('utils.keymap').nmap

require('yanky').setup({
  ring = {
    history_length = 500,
    storage = 'shada',
    sync_with_numbered_registers = true,
    cancel_event = 'update',
  },
  picker = {
    telescope = {
      mappings = {
        default = mapping.put('p'),
        i = {
          ['<cr>'] = mapping.put('p'),
          ['<c-cr>'] = mapping.put('P'),
          ['<c-x>'] = mapping.delete(),
          ['<c-r>'] = mapping.set_register(utils.get_default_register()),
        },
        n = {
          p = mapping.put('p'),
          P = mapping.put('P'),
          d = mapping.delete(),
          r = mapping.set_register(utils.get_default_register())
        },
      }
    }
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 1000,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

-- NOTE: Remaps intentional
set({"n","x"}, "y", "<Plug>(YankyYank)")
set({'n','x'}, 'p', '<plug>(YankyPutAfter)')
set({'n','x'}, 'P', '<plug>(YankyPutBefore)')
set({'n','x'}, 'gp', '<plug>(YankyGPutAfter)')
set({'n','x'}, 'gP', '<plug>(YankyGPutBefore)')
nmap('<c-p>', '<plug>(YankyCycleForward)')
nmap('<c-n>', '<plug>(YankyCycleBackward)')

nmap(']p', '<plug>(YankyPutIndentAfterLinewise)')
nmap('[p', '<plug>(YankyPutIndentBeforeLinewise)')
nmap(']P', '<plug>(YankyPutIndentAfterLinewise)')
nmap('[P', '<plug>(YankyPutIndentBeforeLinewise)')

nmap('>p', '<plug>(YankyPutIndentAfterShiftRight)')
nmap('<p', '<plug>(YankyPutIndentAfterShiftLeft)')
nmap('>P', '<plug>(YankyPutIndentBeforeShiftRight)')
nmap('<P', '<plug>(YankyPutIndentBeforeShiftLeft)')

nmap('=p', '<plug>(YankyPutAfterFilter)')
nmap('=P', '<plug>(YankyPutBeforeFilter)')
