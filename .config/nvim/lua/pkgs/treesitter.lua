require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  ignore_install = {'smali'},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {
      -- Required for spellcheck, some LaTex highlights and
      -- code block highlights that do not have ts grammar
      'org'
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = [[\]],
      node_decremental = [[|]],
    },
  },
})
