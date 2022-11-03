vim.g.mapleader = ' '

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true -- use gui instead of cterm highlight colors

vim.opt.wildmode = 'longest:full,full'  -- command mode completions: longest common substr then cycle options
vim.opt.omnifunc = 'syntaxcomplete#Complete'  -- basic omnifunc for <C-x><C-o> completions
vim.opt.completeopt = "menuone,noselect"

vim.opt.undofile = true      -- persist undos between sessions

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'   -- always show signcolumn
vim.opt.cursorline = true
vim.opt.colorcolumn = '100'
vim.opt.scrolloff = 3

vim.opt.splitbelow = true  -- open splits below
vim.opt.splitright = true  -- open vsplits to right

vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.list = true
vim.opt.listchars = {
  tab =       '» ',
  eol =       '¬',
  trail =     '⋅',
  precedes =  '←',
  extends =   '→',
}
vim.opt.showbreak = '↪ '
vim.opt.fillchars = {
  vert =      '│',
  fold =      ' ',
  foldclose = '─',
  foldopen =  '┬',
  foldsep =   '│',
}
