require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = [[\]],
      node_decremental = [[|]],
    },
  },
})
