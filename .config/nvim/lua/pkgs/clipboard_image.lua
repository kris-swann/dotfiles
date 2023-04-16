require'clipboard-image'.setup {
  default = {
    -- Image dir relative to current file
    img_dir = {"%:p:h", "media"},
    img_dir_txt = "./media",
    img_name = function ()
      -- If in visual mode use selected text
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'v' then
        -- Recover visual selection `gv`, yank it to the `a` register `"ay`, then delete it
        vim.cmd("normal! gv\"ay")
        -- Evaluate contents of `a` register
        local selection = vim.api.nvim_eval("@a")
        -- Delete the selection (to replace with the image text)
        vim.cmd("normal! gvc")
        return selection
      else
        -- Prompt for name
        vim.fn.inputsave()
        local name = vim.fn.input('Image Name: ')
        vim.fn.inputrestore()
        return name
      end
    end,
  },
  markdown = {
    -- Insert alt-text
    img_handler = function(img)
      vim.cmd("normal! f[") -- go to [
      vim.cmd("normal! a" .. img.name) -- append text with image name
    end
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader><C-p>', '<cmd>PasteImg<CR>')
