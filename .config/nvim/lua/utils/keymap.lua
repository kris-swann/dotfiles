-- Stolen from github.com/ThePrimeagen/.dotfiles

local M = {}

local function bind(mode, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend('force',
      outer_opts,
      opts or {}
    )
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- For more info see :help map-modes and :help lua-keymap
M.map = bind('', { noremap = false })
M.noremap = bind('')
M.nmap = bind('n', { noremap = false })
M.nnoremap = bind('n')
M.vnoremap = bind('v')
M.xnoremap = bind('x')
M.inoremap = bind('i')
M.tnoremap = bind('t')
M.onoremap = bind('o')

M.set = vim.keymap.set
M.noreset = function(outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force',
      outer_opts,
      opts or {}
    )
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M