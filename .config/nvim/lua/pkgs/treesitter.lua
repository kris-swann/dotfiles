require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  ignore_install = {'smali'},
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = false,
    -- additional_vim_regex_highlighting = { "markdown" },
    -- disable = { 'markdown' }
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = [[\]],
      node_decremental = [[|]],
    },
  },
})
