require('zen-mode').setup({
  window = {
    backdrop = 1,  -- same color
    width = 75,
    height = 1,
    -- vim.wo options to apply
    options = {
      signcolumn = "no", -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      colorcolumn = "", -- disable colorcolumn
      foldcolumn = "0", -- disable fold column
      list = false, -- disable whitespace characters
      wrap = true,  -- enable soft wraps
      linebreak = true,  -- break at words rather than at width
    },
  },
  plugins = {
    -- vim.o options to apply
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    twilight = { enabled = true }, -- start Twilight when zen mode opens
    gitsigns = { enabled = false }, -- disables git signs
  },
  -- callback where you can add custom code when the Zen window opens
  on_open = function(win)
  end,
  -- callback where you can add custom code when the Zen window closes
  on_close = function()
  end,
})

vim.keymap.set("n", "<leader><leader>z", ":ZenMode<CR>", {})
