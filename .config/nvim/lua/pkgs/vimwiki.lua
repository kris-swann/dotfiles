vim.g.vimwiki_list = {
  { path = '~/Notes', syntax = 'markdown', ext = '.md' },
}

vim.g.vimwiki_key_mappings = {
  -- Disable all default maps except for links
  all_maps = 0,
  links = 1
}
