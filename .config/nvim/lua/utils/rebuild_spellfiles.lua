local last_rebuild_time = -1 -- Persistent between function runs, always rebuild on startup

-- Rebuild *.spl files if necessary (see https://a3nm.net/blog/git_auto_conflicts.html)
local function rebuild_spellfiles()
  for _, add_file in ipairs(vim.fn.glob('~/.config/nvim/spell/*.add', true, true)) do
    local spl_file = add_file .. '.spl'
    -- NOTE: we used to check against vim.fn.getftime(spl_file), but that doesn't work
    -- when there are multiple instances of vim open sharing the same spell files
    local spl_outdated = vim.fn.getftime(add_file) > last_rebuild_time
    if not vim.fn.filereadable(spl_file) or spl_outdated then
      if last_rebuild_time > -1 then print('Rebuilding outdated spellfile ' .. spl_file) end
      vim.cmd('silent mkspell! ' .. add_file)
    end
  end
  last_rebuild_time = tonumber(vim.fn.strftime('%s')) or -1
end

return rebuild_spellfiles
