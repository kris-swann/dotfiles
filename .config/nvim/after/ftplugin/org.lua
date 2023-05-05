local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.cmd('IndentBlanklineDisable')

-- Hack: Must wrap opts in autocmd to play nice with oil.nvim
augroup("notes-org-opts", { clear = true })
autocmd({ "BufWinEnter" }, {
  group = "notes-org-opts",
  pattern = { "*.org" },
  callback = function ()
    vim.opt_local.spell = true
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr="nvim_treesitter#foldexpr()"
    vim.opt_local.foldtext="OrgmodeFoldText()"
    vim.opt_local.foldlevel = 0  -- Fold everything by default
  end,
})

