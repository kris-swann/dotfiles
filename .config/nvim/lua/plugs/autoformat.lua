return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function() require('conform').format({ async = true, lsp_fallback = true }) end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      local buf_ft = vim.bo[bufnr].filetype
      if disable_filetypes[buf_ft] then
        return nil
      else
        return { timeout_ms = 500 }
      end
    end,
    formatters_by_ft = {
      -- ex = { A, { B1, B2 }, C }
      -- Above will run A, B, C sequentially, choosing whichever B1 or B2 is found first
      lua = { 'stylua' },
      python = { 'isort', 'black' },
    },
  },
}
