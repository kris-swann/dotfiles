vim.opt.mouse = 'a' -- Mouse in 'all' modes (NOTE: Quadruple click for visual block mode)

vim.opt.showmode = false -- Don't show mode, it's in the statusline already

vim.opt.ignorecase = true -- Case-insensitive search unless \C or at least one capital
vim.opt.smartcase = true
vim.opt.inccommand = 'split' -- Live substitutions in a preview window

vim.opt.termguicolors = true -- Use gui instead of cterm highlight colors

vim.opt.wildmode = 'longest:full,full' -- Command mode completions: longest common substr then cycle options
vim.opt.omnifunc = 'syntaxcomplete#Complete' -- Basic omnifunc for <C-x><C-o> completions
vim.opt.completeopt = 'menuone,noselect'

vim.opt.undofile = true -- Persist undos between sessions
vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes' -- Always show signcolumn
vim.opt.cursorline = true
vim.opt.colorcolumn = '100'
vim.opt.scrolloff = 3

vim.opt.splitbelow = true -- Open splits below
vim.opt.splitright = true -- Open vsplits to right

vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.shiftround = true

vim.opt.conceallevel = 2

vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  eol = '¬',
  trail = '⋅',
  precedes = '←',
  extends = '→',
}
vim.opt.breakindent = true -- Wrapped lines have same indent
-- vim.opt.showbreak = '↪ '  -- Show this at start of wrapped lines
vim.opt.fillchars = {
  vert = '│',
  fold = ' ',
  foldclose = '─',
  foldopen = '┬',
  foldsep = '│',
}
vim.opt.foldlevelstart = 99 -- Show all folds by default
