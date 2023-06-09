local set = vim.keymap.set

-- Insert tid in insert mode
set('i', '<M-e>', [[tid:<C-r>=strftime('%s')<CR>]]) -- Ex 1686253849
