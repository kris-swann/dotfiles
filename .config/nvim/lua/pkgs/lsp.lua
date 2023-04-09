local lspconfig = require('lspconfig')
local null_ls = require('null-ls')
local keymap = require('utils.keymap')
local nnoremap = keymap.nnoremap

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})

vim.diagnostic.config({
  virtual_text = {
    source = true,
  }
})

local opts = { noremap = true, silent = true }
nnoremap('<leader>e', vim.diagnostic.open_float, opts)
nnoremap('[d', vim.diagnostic.goto_prev, opts)
nnoremap(']d', vim.diagnostic.goto_next, opts)
nnoremap('<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  buf_set_keymap('n', ',s', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true})<CR>', opts)
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
  'eslint',
  'graphql',
  'rust_analyzer',
  'svelte',
  'kotlin_language_server',
}
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
  })
end

lspconfig.tsserver.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
}

lspconfig.denols.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

-- Neodev lsp setup
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

null_ls.setup({
  -- log_level = 'trace',
  -- root_dir = where the command is spawned
  root_dir = require('null-ls.utils').root_pattern(
    ".null-ls-root", "Makefile", ".git", -- Default
    "node_modules"-- Also include node_modules for mono_repos
  ),
  sources = {
    null_ls.builtins.diagnostics.textlint.with({
      filetypes = { 'markdown' },
      prefer_local = 'node_modules/.bin',
    }),
  },
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

require('trouble').setup({})

require('fidget').setup()

require('lspkind').init({})
