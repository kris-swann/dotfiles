require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,  -- All servers set up via lspconfig are automatically installed
})
require("mason-null-ls").setup({
  automatic_installation = true,  -- All servers set up via lspconfig are automatically installed
})
