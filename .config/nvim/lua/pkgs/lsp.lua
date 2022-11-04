local lspconfig = require('lspconfig')
--local null_ls = require("null-ls")
local keymap = require('utils.keymap')
local nnoremap = keymap.nnoremap

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})

local opts = { noremap = true, silent = true }
nnoremap('<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
nnoremap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
nnoremap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
nnoremap('<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

local on_attach = function(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  buf_set_keymap('n', ',s', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- TODO move these to a telescope list
  buf_set_keymap('n', '<leader>laf', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>lrf', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>llf', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  --[[ These are now being managed via telescope
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  ]]
end

-- For install info/all supported lsp's :help lspconfig-server-configurations
local servers = {
  'pyright',
  'prismals',
  'tsserver',
  'eslint',
  'graphql',
  'rust_analyzer',
  'svelte',
  'gopls',
}
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
  })
end


-- Neodev lsp setup
lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

--[[ Currently this breaks :LSPInfo
null_ls.setup({
  debug = true,
  sources = {
    -- null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.code_actions.shellcheck,

    -- null_ls.builtins.completion.spell,
    -- null_ls.builtins.completion.luasnip,

    -- null_ls.builtins.diagnostics.editorconfig_checker,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.jsonlint,
    -- null_ls.builtins.diagnostics.markdownlint,
    -- null_ls.builtins.diagnostics.misspell,
    -- null_ls.builtins.diagnostics.proselint,
    -- null_ls.builtins.diagnostics.pycodestyle,
    -- null_ls.builtins.diagnostics.pydocstyle,
    -- null_ls.builtins.diagnostics.pylint,
    -- null_ls.builtins.diagnostics.pyproject_flake8,
    -- null_ls.builtins.diagnostics.selene,
    -- null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.diagnostics.tsc,
    -- null_ls.builtins.diagnostics.trail_space,
    -- null_ls.builtins.diagnostics.vale,
    -- null_ls.builtins.diagnostics.write_good,
    -- null_ls.builtins.diagnostics.xo,
    -- null_ls.builtins.diagnostics.yamllint,
    -- null_ls.builtins.diagnostics.zsh,

    -- null_ls.builtins.formatting.black,
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.eslint,
    -- null_ls.builtins.formatting.fixjson,
    -- null_ls.builtins.formatting.isort,
    -- null_ls.builtins.formatting.prettier,
    -- null_ls.builtins.formatting.prismaFmt,
    -- null_ls.builtins.formatting.rustfmt,
    -- null_ls.builtins.formatting.shfmt,
    -- null_ls.builtins.formatting.terraform_fmt,
    -- null_ls.builtins.formatting.tidy,

    -- null_ls.builtins.hover.dictionary,
    -- null_ls.builtins.hover.printenv,
  },
})
]]


require('fidget').setup()

require('lspkind').init({})