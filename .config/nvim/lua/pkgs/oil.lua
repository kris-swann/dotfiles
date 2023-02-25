require("oil").setup({
  columns = {
    "icon",
    "size",
    "permissions",
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
    ["g/"] = "actions.copy_entry_path",
  },
})

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
