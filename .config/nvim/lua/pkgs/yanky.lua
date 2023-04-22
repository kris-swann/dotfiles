local utils = require('yanky.utils')
local mapping = require('yanky.telescope.mapping')
local set = vim.keymap.set

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

set('n', '<c-p>', '<plug>(YankyCycleForward)', { noremap = false })
set('n', '<c-n>', '<plug>(YankyCycleBackward)', { noremap = false })

set('n', ']p', '<plug>(YankyPutIndentAfterLinewise)', { noremap = false })
set('n', '[p', '<plug>(YankyPutIndentBeforeLinewise)', { noremap = false })
set('n', ']P', '<plug>(YankyPutIndentAfterLinewise)', { noremap = false })
set('n', '[P', '<plug>(YankyPutIndentBeforeLinewise)', { noremap = false })

set('n', '>p', '<plug>(YankyPutIndentAfterShiftRight)', { noremap = false })
set('n', '<p', '<plug>(YankyPutIndentAfterShiftLeft)', { noremap = false })
set('n', '>P', '<plug>(YankyPutIndentBeforeShiftRight)', { noremap = false })
set('n', '<P', '<plug>(YankyPutIndentBeforeShiftLeft)', { noremap = false })

set('n', '=p', '<plug>(YankyPutAfterFilter)', { noremap = false })
set('n', '=P', '<plug>(YankyPutBeforeFilter)', { noremap = false })
