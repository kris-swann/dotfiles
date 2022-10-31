-- Rebuild *.spl files if necessary (see https://a3nm.net/blog/git_auto_conflicts.html)
local function rebuild_spellfiles()
  for _, add_file in ipairs(vim.fn.glob('~/.config/nvim/spell/*.add', 1, 1)) do
    local spl_file = add_file .. '.spl'
    local spl_outdated = vim.fn.getftime(add_file) > vim.fn.getftime(spl_file)
    if not vim.fn.filereadable(spl_file) or spl_outdated then
      vim.cmd('silent mkspell! ' .. add_file)
    end
  end
end

return rebuild_spellfiles
