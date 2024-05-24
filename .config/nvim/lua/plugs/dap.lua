return { -- DAP/Debugger
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui', -- Debugger UI
    'nvim-neotest/nvim-nio', -- Req dep for nvim-dap-ui

    -- Autoinstall debug adapters
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Custom debuggers
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Autoinstall debug adapters
    require('mason-nvim-dap').setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Golang
      },
    })

    dapui.setup()
    require('dap-go').setup()

    -- Which-key prefixes
    pcall(require('which-key').register, {
      ['<leader>b'] = { name = 'Debug', _ = 'which_key_ignore' },
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>bn', dap.continue, { desc = 'Start/Continue [N]ext' })
    vim.keymap.set('n', '<leader>bi', dap.step_into, { desc = 'Step [I]nto' })
    vim.keymap.set('n', '<leader>bo', dap.step_over, { desc = 'Step [O]ver' })
    vim.keymap.set('n', '<leader>bp', dap.step_out, { desc = 'Step Out [P]rev' })
    vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set(
      'n',
      '<leader>bB',
      function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
      { desc = 'Set Breakpoint with condition' }
    )
    -- See last session result, needed to see output in case of unhandled exception
    vim.keymap.set('n', '<leader>br', dapui.toggle, { desc = 'See last session [R]esult' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
