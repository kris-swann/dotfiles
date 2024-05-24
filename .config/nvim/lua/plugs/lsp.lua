--
-- NOTE: Assumes that telescope and cmp will be available
--

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true }, -- Auto install LSPs, etc (MUST be loaded deps)
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    { 'j-hui/fidget.nvim', opts = {} }, -- LSP loading indicator

    { 'folke/neodev.nvim', opts = {} }, -- Additional LSP config for lua nvim apis
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        -- Helpful wrapper function
        local buf_set = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
        end

        -- Which-key prefixes
        pcall(require('which-key').register, {
          ['<leader>l'] = { name = '[L]SP', _ = 'which_key_ignore' },
          ['<leader>lw'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        })

        -- Keybinds
        buf_set('K', vim.lsp.buf.hover, 'LSP: Hover Documentation') -- See :help K for why this keymap
        buf_set('<C-k>', vim.lsp.buf.signature_help, 'LSP: Signature Documentation')

        buf_set('gd', require('telescope.builtin').lsp_definitions, 'LSP: Goto [D]efinition')
        buf_set('gD', vim.lsp.buf.declaration, 'LSP: Goto [D]eclaration')
        buf_set(
          '<leader>d',
          require('telescope.builtin').lsp_type_definitions,
          'LSP: Goto Type [D]efinition'
        )
        buf_set('gr', require('telescope.builtin').lsp_references, 'LSP: Goto [R]eferences')
        buf_set(
          'gI',
          require('telescope.builtin').lsp_implementations,
          'LSP: Goto [I]mplementation'
        )

        -- Dupes of above in <leader>l namespace (with main keybind for discoverability)
        buf_set('<leader>ld', require('telescope.builtin').lsp_definitions, '[D]efinition (gd)')
        buf_set('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration (gD)')
        buf_set(
          '<leader>lt',
          require('telescope.builtin').lsp_type_definitions,
          '[T]ype Definition (<leader>D)'
        )
        buf_set('<leader>lr', require('telescope.builtin').lsp_references, '[R]eferences (gr)')
        buf_set(
          '<leader>lI',
          require('telescope.builtin').lsp_implementations,
          '[I]mplementation (gI)'
        )

        buf_set('<leader>li', require('telescope.builtin').lsp_incoming_calls, '[I]ncoming calls')
        buf_set('<leader>lo', require('telescope.builtin').lsp_outgoing_calls, '[O]utgoing calls')
        buf_set('<leader>lR', vim.lsp.buf.rename, '[R]ename')
        buf_set('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')
        buf_set(
          '<leader>ls',
          require('telescope.builtin').lsp_document_symbols,
          '[S]ymbols for cur buffer'
        )

        buf_set(
          '<leader>lws',
          require('telescope.builtin').lsp_dynamic_workspace_symbols,
          '[S]ymbols for Workspace'
        )
        buf_set('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[A]dd Workspace Folder')
        buf_set('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[R]emove Workspace Folder')
        buf_set('<leader>lwl', vim.lsp.buf.list_workspace_folders, '[A]dd Workspace Folder')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- If supported, toggle inlay hints (WARNING: They displace some of your code)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          buf_set(
            '<leader>lh',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
            'Toggle Inlay [H]ints'
          )
        end

        if client and client.server_capabilities.documentHighlightProvider then
          -- Highlight references when cursor in same spot for a little while (:help CursorHold)
          local highlight_augroup =
            vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Clear highlights when cursor is moved
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          -- Clear highlights when LSP is detatched from buffer
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
            end,
          })
        end
      end,
    })

    -- LSP servers and clients broadcast what features they support to each other.
    -- By default, nvim doesn't support all LSP features.
    -- With nvim-cmp, luasnip, etc, nvim has additional capabilities.
    -- So we update the list of capabilities that are broadcasted to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities =
      vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override default command used to start the server
    --  - filetypes (table): Override default list of filetypes
    --  - capabilities (table): Override capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override default settings passed when initializing the server.
    local servers = {
      -- pyright = {},
      -- prismals = {},
      -- eslint = {},
      -- graphql = {},
      -- rust_analyzer = {},
      -- svelte = {},
      -- tsserver = {}, -- Also see pmizio/typescript-tools.nvim
      marksman = {},
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- Ignore noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require('mason').setup()

    -- Other tools to auto install via mason
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities =
            vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })
  end,
}
