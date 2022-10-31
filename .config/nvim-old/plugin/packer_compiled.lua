-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/kris/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/kris/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/kris/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/kris/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/kris/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ale = {
    config = { "\27LJ\2\nî\b\0\0\a\0.\0X6\0\0\0009\0\1\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\1=\1\2\0006\0\b\0'\2\t\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\b\0'\2\t\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\1\0'\1\17\0=\1\16\0006\0\0\0009\0\1\0'\1\19\0=\1\18\0006\0\0\0009\0\1\0'\1\21\0=\1\20\0006\0\0\0009\0\1\0)\1\1\0=\1\22\0006\0\23\0'\2\24\0B\0\2\0026\1\0\0009\1\25\1'\3\26\0009\4\27\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\25\1'\3\30\0009\4\31\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\25\1'\3 \0009\4!\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\1\1'\2#\0=\2\"\0016\1\0\0009\1\1\1'\2%\0=\2$\0016\1\0\0009\1\1\1'\2'\0=\2&\0016\1\0\0009\1\1\1'\2)\0=\2(\0016\1\0\0009\1\1\1'\2+\0=\2*\0016\1\0\0009\1\1\1'\2-\0=\2,\1K\0\1\0\31-- -Wall -std=c++11 -x c++\31ale_cpp_clangcheck_options\28-Wall -std=c++11 -x c++\30ale_cpp_clangtidy_options\boff'ale_python_flake8_change_directory\bÔüº\18ale_sign_info\bÔî©\21ale_sign_warning\bÔôô\19ale_sign_error\14dark_cyan!highlight ALEInfoSign guifg=\16dark_yellow$highlight ALEWarningSign guifg=\bbg0\f guibg=\rdark_red\"highlight ALEErrorSign guifg=\bcmd\19onedark.colors\frequire\27ale_virtualtext_cursor([%severity%] [%linter%] %[code]% %s\24ale_echo_msg_format\6W\29ale_echo_msg_warning_str\6E\27ale_echo_msg_error_str\1\0\1\vsilent\2\25<cmd>ALENextWrap<CR>\n<C-j>\1\0\1\vsilent\2\29<cmd>ALEPreviousWrap<CR>\n<C-k>\6n\vkeymap\15typescript\1\6\0\0\veslint\rprettier\rstandard\vtslint\14typecheck\vpython\1\0\0\1\3\0\0\vflake8\vpylint\16ale_linters\6g\bvim\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/ale",
    url = "https://github.com/w0rp/ale"
  },
  ["bclose.vim"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/bclose.vim",
    url = "https://github.com/rbgrouleff/bclose.vim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  fzf = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\2\n…\1\0\0\6\0\n\0\0176\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\b\0'\4\t\0004\5\0\0B\0\5\1K\0\1\0\19<cmd>Files<CR>\15<leader>af\22<cmd>GitFiles<CR>\14<leader>f\5\vkeymap\1\0\3\vctrl-t\14tab split\vctrl-v\vvsplit\vctrl-s\nsplit\15fzf_action\6g\bvim\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nñ\1\0\4\v\1\6\0\0196\4\0\0009\4\1\4'\6\2\0005\a\3\0\f\b\3\0X\b\1Ä4\b\0\0B\4\4\2\18\3\4\0006\4\0\0009\4\4\0049\4\5\4-\6\0\0\18\a\0\0\18\b\1\0\18\t\2\0\18\n\3\0B\4\6\1K\0\1\0\0¿\24nvim_buf_set_keymap\bapi\1\0\2\vsilent\2\fnoremap\2\nforce\15tbl_extend\bvimÑ\a\1\1\b\0\31\0P3\1\0\0\18\2\1\0'\4\1\0'\5\2\0'\6\3\0005\a\4\0B\2\5\1\18\2\1\0'\4\1\0'\5\5\0'\6\6\0005\a\a\0B\2\5\1\18\2\1\0'\4\1\0'\5\b\0'\6\t\0B\2\4\1\18\2\1\0'\4\n\0'\5\b\0'\6\t\0B\2\4\1\18\2\1\0'\4\1\0'\5\v\0'\6\f\0B\2\4\1\18\2\1\0'\4\n\0'\5\v\0'\6\f\0B\2\4\1\18\2\1\0'\4\1\0'\5\r\0'\6\14\0B\2\4\1\18\2\1\0'\4\1\0'\5\15\0'\6\16\0B\2\4\1\18\2\1\0'\4\1\0'\5\17\0'\6\18\0B\2\4\1\18\2\1\0'\4\1\0'\5\19\0'\6\20\0B\2\4\1\18\2\1\0'\4\1\0'\5\21\0'\6\22\0B\2\4\1\18\2\1\0'\4\1\0'\5\23\0'\6\24\0B\2\4\1\18\2\1\0'\4\1\0'\5\25\0'\6\26\0B\2\4\1\18\2\1\0'\4\27\0'\5\28\0'\6\29\0B\2\4\1\18\2\1\0'\4\30\0'\5\28\0'\6\29\0B\2\4\0012\0\0ÄK\0\1\0\6x#:<C-U>Gitsigns select_hunk<CR>\aih\6o%<cmd>Gitsigns toggle_deleted<CR>\15<leader>td1<cmd>lua require\"gitsigns\".diffthis(\"~\")<CR>\15<leader>hD\31<cmd>Gitsigns diffthis<CR>\15<leader>hd0<cmd>Gitsigns toggle_current_line_blame<CR>\15<leader>tb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\15<leader>hb#<cmd>Gitsigns preview_hunk<CR>\15<leader>hp&<cmd>Gitsigns undo_stage_hunk<CR>\15<leader>hu\29:Gitsigns reset_hunk<CR>\15<leader>hr\6v\29:Gitsigns stage_hunk<CR>\15<leader>hs\1\0\1\texpr\0021&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\a[c\1\0\1\texpr\0021&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\a]c\6n\0™\4\1\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0023\3\16\0=\3\17\2B\0\2\1K\0\1\0\14on_attach\0\nsigns\1\0\0\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚îÇ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚îÇ\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\b‚îÇ\vlinehl\18GitSignsAddLn\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nÑ\4\0\0\6\0\15\0%6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\b\0'\4\t\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\n\0'\4\v\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\f\0'\4\r\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\14\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\r<space>/C<cmd>lua require\"hop\".hint_lines({ multi_windows = true })<CR>\r<space>lC<cmd>lua require\"hop\".hint_char1({ multi_windows = true })<CR>\r<space>cC<cmd>lua require\"hop\".hint_words({ multi_windows = true })<CR>\r<space>wF<cmd>lua require\"hop\".hint_patterns({ multi_windows = true })<CR>\19<space><space>\5\vkeymap\1\0\1\tkeys\25danesirhculofypmgvbw\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n¿\a\0\0\a\0!\00136\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0036\4\a\0009\4\b\0046\6\t\0009\6\n\0069\6\v\6\24\6\0\6B\4\2\2=\4\f\3=\3\r\0025\3\14\0=\3\15\2B\0\2\0016\0\16\0'\2\17\0'\3\18\0'\4\19\0005\5\20\0B\0\5\0016\0\16\0'\2\17\0'\3\21\0'\4\22\0005\5\23\0B\0\5\0016\0\16\0'\2\17\0'\3\24\0'\4\25\0005\5\26\0B\0\5\0016\0\16\0'\2\17\0'\3\27\0'\4\28\0005\5\29\0B\0\5\0016\0\16\0'\2\17\0'\3\30\0'\4\31\0005\5 \0B\0\5\1K\0\1\0\1\0\3\vsilent\2\texpr\2\fnoremap\2\"compe#scroll({ 'delta': -4 })\n<C-d>\1\0\3\vsilent\2\texpr\2\fnoremap\2\"compe#scroll({ 'delta': +4 })\n<C-f>\1\0\3\vsilent\2\texpr\2\fnoremap\2\25compe#close('<C-e>')\n<C-e>\1\0\3\vsilent\2\texpr\2\fnoremap\2\26compe#confirm('<CR>')\t<CR>\1\0\3\vsilent\2\texpr\2\fnoremap\2\21compe#complete()\14<C-space>\6i\vkeymap\vsource\1\0\5\rnvim_lsp\2\vbuffer\2\rnvim_lua\2\tcalc\2\tpath\2\18documentation\15max_height\nlines\6o\bvim\nfloor\tmath\vborder\1\0\4\14max_width\3x\14min_width\3<\15min_height\3\1\17winhighlightHNormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder\1\t\0\0\5\5\5\6 \5\5\5\6 \1\0\f\20resolve_timeout\3†\6\19source_timeout\3»\1\18throttle_time\3P\14preselect\venable\15min_length\3\1\17autocomplete\2\fenabled\2\ndebug\1\19max_menu_width\3d\19max_kind_width\3d\19max_abbr_width\3d\21incomplete_delay\3ê\3\nsetup\ncompe\frequireÁÃô≥\6≥ÊÃ˛\3\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/nvim-compe",
    url = "https://github.com/hrsh7th/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimê\b\1\2\n\0\31\0X3\2\0\0005\3\1\0\18\4\2\0'\6\2\0'\a\3\0'\b\4\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\5\0'\b\6\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\a\0'\b\b\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\t\0'\b\n\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\v\0'\b\f\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\r\0'\b\14\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\15\0'\b\16\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\17\0'\b\18\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\19\0'\b\20\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\21\0'\b\22\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\23\0'\b\24\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\25\0'\b\26\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\27\0'\b\28\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\29\0'\b\30\0\18\t\3\0B\4\5\0012\0\0ÄK\0\1\0*<cmd>lua vim.lsp.buf.formatting()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>D.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<Cmd>lua vim.lsp.buf.hover()<CR>\6K*<Cmd>lua vim.lsp.buf.definition()<CR>\agd+<Cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\1\0\2\vsilent\2\fnoremap\2\0Ë\1\1\0\f\0\n\0\0226\0\0\0'\2\1\0B\0\2\0023\1\2\0005\2\3\0006\3\4\0\18\5\2\0B\3\2\4H\6\nÄ6\b\0\0'\n\1\0B\b\2\0028\b\a\b9\b\5\b5\n\6\0=\1\a\n5\v\b\0=\v\t\nB\b\2\1F\6\3\3R\6Ù\127K\0\1\0\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\nsetup\npairs\1\a\0\0\fpyright\rprismals\rtsserver\veslint\fgraphql\18rust_analyzer\0\14lspconfig\frequire\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n≠\2\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\2B\0\2\1K\0\1\0\26incremental_selection\fkeymaps\1\0\2\21node_decremental\6|\21node_incremental\6\\\1\0\1\venable\2\14highlight\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\1\3\0\0\fhaskell\vphpdoc\1\0\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["ranger.vim"] = {
    config = { "\27LJ\2\në\1\0\0\6\0\b\0\0156\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0006\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\20<cmd>Ranger<CR>\14<leader>e\6n\vkeymap\20ranger_map_keys\25ranger_replace_netrw\6g\bvim\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/ranger.vim",
    url = "https://github.com/francoiscabrol/ranger.vim"
  },
  tabular = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-hexokinase"] = {
    config = { "\27LJ\2\n•\1\0\0\2\0\6\0\t6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\2\0\0007full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names\29Hexokinase_optInPatterns\1\2\0\0\fvirtual\28Hexokinase_highlighters\6g\bvim\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-hexokinase",
    url = "https://github.com/rrethy/vim-hexokinase"
  },
  ["vim-prettier"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-prettier",
    url = "https://github.com/prettier/vim-prettier"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-yoink"] = {
    config = { "\27LJ\2\nÔ\1\0\0\6\0\n\0\0256\0\0\0'\2\1\0'\3\2\0'\4\3\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\b\0'\4\t\0004\5\0\0B\0\5\1K\0\1\0\25<plug>(YoinkPaste_P)\6P\25<plug>(YoinkPaste_p)\6p#<plug>(YoinkPostPasteSwapBack)\n<C-p>&<plug>(YoinkPostPasteSwapForward)\n<C-n>\6n\vkeymap\0" },
    loaded = true,
    path = "/home/kris/.local/share/nvim/site/pack/packer/start/vim-yoink",
    url = "https://github.com/svermeulen/vim-yoink"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nñ\1\0\4\v\1\6\0\0196\4\0\0009\4\1\4'\6\2\0005\a\3\0\f\b\3\0X\b\1Ä4\b\0\0B\4\4\2\18\3\4\0006\4\0\0009\4\4\0049\4\5\4-\6\0\0\18\a\0\0\18\b\1\0\18\t\2\0\18\n\3\0B\4\6\1K\0\1\0\0¿\24nvim_buf_set_keymap\bapi\1\0\2\vsilent\2\fnoremap\2\nforce\15tbl_extend\bvimÑ\a\1\1\b\0\31\0P3\1\0\0\18\2\1\0'\4\1\0'\5\2\0'\6\3\0005\a\4\0B\2\5\1\18\2\1\0'\4\1\0'\5\5\0'\6\6\0005\a\a\0B\2\5\1\18\2\1\0'\4\1\0'\5\b\0'\6\t\0B\2\4\1\18\2\1\0'\4\n\0'\5\b\0'\6\t\0B\2\4\1\18\2\1\0'\4\1\0'\5\v\0'\6\f\0B\2\4\1\18\2\1\0'\4\n\0'\5\v\0'\6\f\0B\2\4\1\18\2\1\0'\4\1\0'\5\r\0'\6\14\0B\2\4\1\18\2\1\0'\4\1\0'\5\15\0'\6\16\0B\2\4\1\18\2\1\0'\4\1\0'\5\17\0'\6\18\0B\2\4\1\18\2\1\0'\4\1\0'\5\19\0'\6\20\0B\2\4\1\18\2\1\0'\4\1\0'\5\21\0'\6\22\0B\2\4\1\18\2\1\0'\4\1\0'\5\23\0'\6\24\0B\2\4\1\18\2\1\0'\4\1\0'\5\25\0'\6\26\0B\2\4\1\18\2\1\0'\4\27\0'\5\28\0'\6\29\0B\2\4\1\18\2\1\0'\4\30\0'\5\28\0'\6\29\0B\2\4\0012\0\0ÄK\0\1\0\6x#:<C-U>Gitsigns select_hunk<CR>\aih\6o%<cmd>Gitsigns toggle_deleted<CR>\15<leader>td1<cmd>lua require\"gitsigns\".diffthis(\"~\")<CR>\15<leader>hD\31<cmd>Gitsigns diffthis<CR>\15<leader>hd0<cmd>Gitsigns toggle_current_line_blame<CR>\15<leader>tb9<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>\15<leader>hb#<cmd>Gitsigns preview_hunk<CR>\15<leader>hp&<cmd>Gitsigns undo_stage_hunk<CR>\15<leader>hu\29:Gitsigns reset_hunk<CR>\15<leader>hr\6v\29:Gitsigns stage_hunk<CR>\15<leader>hs\1\0\1\texpr\0021&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'\a[c\1\0\1\texpr\0021&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'\a]c\6n\0™\4\1\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0023\3\16\0=\3\17\2B\0\2\1K\0\1\0\14on_attach\0\nsigns\1\0\0\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚îÇ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚îÇ\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\b‚îÇ\vlinehl\18GitSignsAddLn\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: fzf.vim
time([[Config for fzf.vim]], true)
try_loadstring("\27LJ\2\n…\1\0\0\6\0\n\0\0176\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\b\0'\4\t\0004\5\0\0B\0\5\1K\0\1\0\19<cmd>Files<CR>\15<leader>af\22<cmd>GitFiles<CR>\14<leader>f\5\vkeymap\1\0\3\vctrl-t\14tab split\vctrl-v\vvsplit\vctrl-s\nsplit\15fzf_action\6g\bvim\0", "config", "fzf.vim")
time([[Config for fzf.vim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimê\b\1\2\n\0\31\0X3\2\0\0005\3\1\0\18\4\2\0'\6\2\0'\a\3\0'\b\4\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\5\0'\b\6\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\a\0'\b\b\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\t\0'\b\n\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\v\0'\b\f\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\r\0'\b\14\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\15\0'\b\16\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\17\0'\b\18\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\19\0'\b\20\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\21\0'\b\22\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\23\0'\b\24\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\25\0'\b\26\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\27\0'\b\28\0\18\t\3\0B\4\5\1\18\4\2\0'\6\2\0'\a\29\0'\b\30\0\18\t\3\0B\4\5\0012\0\0ÄK\0\1\0*<cmd>lua vim.lsp.buf.formatting()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>D.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<Cmd>lua vim.lsp.buf.hover()<CR>\6K*<Cmd>lua vim.lsp.buf.definition()<CR>\agd+<Cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\1\0\2\vsilent\2\fnoremap\2\0Ë\1\1\0\f\0\n\0\0226\0\0\0'\2\1\0B\0\2\0023\1\2\0005\2\3\0006\3\4\0\18\5\2\0B\3\2\4H\6\nÄ6\b\0\0'\n\1\0B\b\2\0028\b\a\b9\b\5\b5\n\6\0=\1\a\n5\v\b\0=\v\t\nB\b\2\1F\6\3\3R\6Ù\127K\0\1\0\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\nsetup\npairs\1\a\0\0\fpyright\rprismals\rtsserver\veslint\fgraphql\18rust_analyzer\0\14lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n¿\a\0\0\a\0!\00136\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0036\4\a\0009\4\b\0046\6\t\0009\6\n\0069\6\v\6\24\6\0\6B\4\2\2=\4\f\3=\3\r\0025\3\14\0=\3\15\2B\0\2\0016\0\16\0'\2\17\0'\3\18\0'\4\19\0005\5\20\0B\0\5\0016\0\16\0'\2\17\0'\3\21\0'\4\22\0005\5\23\0B\0\5\0016\0\16\0'\2\17\0'\3\24\0'\4\25\0005\5\26\0B\0\5\0016\0\16\0'\2\17\0'\3\27\0'\4\28\0005\5\29\0B\0\5\0016\0\16\0'\2\17\0'\3\30\0'\4\31\0005\5 \0B\0\5\1K\0\1\0\1\0\3\vsilent\2\texpr\2\fnoremap\2\"compe#scroll({ 'delta': -4 })\n<C-d>\1\0\3\vsilent\2\texpr\2\fnoremap\2\"compe#scroll({ 'delta': +4 })\n<C-f>\1\0\3\vsilent\2\texpr\2\fnoremap\2\25compe#close('<C-e>')\n<C-e>\1\0\3\vsilent\2\texpr\2\fnoremap\2\26compe#confirm('<CR>')\t<CR>\1\0\3\vsilent\2\texpr\2\fnoremap\2\21compe#complete()\14<C-space>\6i\vkeymap\vsource\1\0\5\rnvim_lsp\2\vbuffer\2\rnvim_lua\2\tcalc\2\tpath\2\18documentation\15max_height\nlines\6o\bvim\nfloor\tmath\vborder\1\0\4\14max_width\3x\14min_width\3<\15min_height\3\1\17winhighlightHNormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder\1\t\0\0\5\5\5\6 \5\5\5\6 \1\0\f\20resolve_timeout\3†\6\19source_timeout\3»\1\18throttle_time\3P\14preselect\venable\15min_length\3\1\17autocomplete\2\fenabled\2\ndebug\1\19max_menu_width\3d\19max_kind_width\3d\19max_abbr_width\3d\21incomplete_delay\3ê\3\nsetup\ncompe\frequireÁÃô≥\6≥ÊÃ˛\3\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: ranger.vim
time([[Config for ranger.vim]], true)
try_loadstring("\27LJ\2\në\1\0\0\6\0\b\0\0156\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0006\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\20<cmd>Ranger<CR>\14<leader>e\6n\vkeymap\20ranger_map_keys\25ranger_replace_netrw\6g\bvim\0", "config", "ranger.vim")
time([[Config for ranger.vim]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n≠\2\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\2B\0\2\1K\0\1\0\26incremental_selection\fkeymaps\1\0\2\21node_decremental\6|\21node_incremental\6\\\1\0\1\venable\2\14highlight\1\0\2&additional_vim_regex_highlighting\1\venable\2\19ignore_install\1\3\0\0\fhaskell\vphpdoc\1\0\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vim-hexokinase
time([[Config for vim-hexokinase]], true)
try_loadstring("\27LJ\2\n•\1\0\0\2\0\6\0\t6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\2\0\0007full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names\29Hexokinase_optInPatterns\1\2\0\0\fvirtual\28Hexokinase_highlighters\6g\bvim\0", "config", "vim-hexokinase")
time([[Config for vim-hexokinase]], false)
-- Config for: ale
time([[Config for ale]], true)
try_loadstring("\27LJ\2\nî\b\0\0\a\0.\0X6\0\0\0009\0\1\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\1=\1\2\0006\0\b\0'\2\t\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\b\0'\2\t\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\1\0'\1\17\0=\1\16\0006\0\0\0009\0\1\0'\1\19\0=\1\18\0006\0\0\0009\0\1\0'\1\21\0=\1\20\0006\0\0\0009\0\1\0)\1\1\0=\1\22\0006\0\23\0'\2\24\0B\0\2\0026\1\0\0009\1\25\1'\3\26\0009\4\27\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\25\1'\3\30\0009\4\31\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\25\1'\3 \0009\4!\0'\5\28\0009\6\29\0&\3\6\3B\1\2\0016\1\0\0009\1\1\1'\2#\0=\2\"\0016\1\0\0009\1\1\1'\2%\0=\2$\0016\1\0\0009\1\1\1'\2'\0=\2&\0016\1\0\0009\1\1\1'\2)\0=\2(\0016\1\0\0009\1\1\1'\2+\0=\2*\0016\1\0\0009\1\1\1'\2-\0=\2,\1K\0\1\0\31-- -Wall -std=c++11 -x c++\31ale_cpp_clangcheck_options\28-Wall -std=c++11 -x c++\30ale_cpp_clangtidy_options\boff'ale_python_flake8_change_directory\bÔüº\18ale_sign_info\bÔî©\21ale_sign_warning\bÔôô\19ale_sign_error\14dark_cyan!highlight ALEInfoSign guifg=\16dark_yellow$highlight ALEWarningSign guifg=\bbg0\f guibg=\rdark_red\"highlight ALEErrorSign guifg=\bcmd\19onedark.colors\frequire\27ale_virtualtext_cursor([%severity%] [%linter%] %[code]% %s\24ale_echo_msg_format\6W\29ale_echo_msg_warning_str\6E\27ale_echo_msg_error_str\1\0\1\vsilent\2\25<cmd>ALENextWrap<CR>\n<C-j>\1\0\1\vsilent\2\29<cmd>ALEPreviousWrap<CR>\n<C-k>\6n\vkeymap\15typescript\1\6\0\0\veslint\rprettier\rstandard\vtslint\14typecheck\vpython\1\0\0\1\3\0\0\vflake8\vpylint\16ale_linters\6g\bvim\0", "config", "ale")
time([[Config for ale]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nÑ\4\0\0\6\0\15\0%6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\4\0'\2\5\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\b\0'\4\t\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\n\0'\4\v\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\f\0'\4\r\0004\5\0\0B\0\5\0016\0\4\0'\2\5\0'\3\14\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\r<space>/C<cmd>lua require\"hop\".hint_lines({ multi_windows = true })<CR>\r<space>lC<cmd>lua require\"hop\".hint_char1({ multi_windows = true })<CR>\r<space>cC<cmd>lua require\"hop\".hint_words({ multi_windows = true })<CR>\r<space>wF<cmd>lua require\"hop\".hint_patterns({ multi_windows = true })<CR>\19<space><space>\5\vkeymap\1\0\1\tkeys\25danesirhculofypmgvbw\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: vim-yoink
time([[Config for vim-yoink]], true)
try_loadstring("\27LJ\2\nÔ\1\0\0\6\0\n\0\0256\0\0\0'\2\1\0'\3\2\0'\4\3\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\6\0'\4\a\0004\5\0\0B\0\5\0016\0\0\0'\2\1\0'\3\b\0'\4\t\0004\5\0\0B\0\5\1K\0\1\0\25<plug>(YoinkPaste_P)\6P\25<plug>(YoinkPaste_p)\6p#<plug>(YoinkPostPasteSwapBack)\n<C-p>&<plug>(YoinkPostPasteSwapForward)\n<C-n>\6n\vkeymap\0", "config", "vim-yoink")
time([[Config for vim-yoink]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
