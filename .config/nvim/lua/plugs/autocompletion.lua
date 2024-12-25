return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { -- Snippets
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step needed for regex support in snippets
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        { -- Collection of premade snippets
          'rafamadriz/friendly-snippets',
          config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- Source: luasnip

    -- { -- AI
    --   'Exafunction/codeium.vim',
    --   -- Using this instead of codeium.nvim b/c codeium.nvim only works as a cmp source
    --   -- but I want it seperate from cmp
    --   event = 'BufEnter',
    --   config = function()
    --     vim.g.codeium_disable_bindings = 1 -- Disable default keybinds
    --     -- vim.g.codeium_manual = true
    --     -- vim.keymap.set(
    --     --   'i',
    --     --   '<C-/>',
    --     --   function() return vim.fn['codeium#Complete']() end,
    --     --   { expr = true, silent = true, desc = 'AI Codeium Trigger' }
    --     -- )
    --     vim.keymap.set(
    --       'i',
    --       '<C-\\>',
    --       function() return vim.fn['codeium#Accept']() end,
    --       { expr = true, silent = true, desc = 'AI Codeium Accept' }
    --     )
    --     vim.keymap.set(
    --       'i',
    --       '<C-,>',
    --       function() return vim.fn['codeium#CycleCompletions'](1) end,
    --       { expr = true, silent = true, desc = 'AI Codeium Next Suggestion' }
    --     )
    --     vim.keymap.set(
    --       'i',
    --       '<C-.>',
    --       function() return vim.fn['codeium#CycleCompletions'](-1) end,
    --       { expr = true, silent = true, desc = 'AI Codeium Prev Suggestion' }
    --     )
    --     vim.keymap.set(
    --       'i',
    --       '<C-/>',
    --       function() return vim.fn['codeium#Clear']() end,
    --       { expr = true, silent = true, desc = 'AI Codeium Clear' }
    --     )
    --   end,
    -- },

    -- 'onsails/lspkind.nvim', -- Pictograms for different lsp obj types

    'hrsh7th/cmp-calc', -- Source: Math expressions (No text/comment delimiters allowed before)
    'hrsh7th/cmp-path', -- Source: filesystem paths

    'hrsh7th/cmp-nvim-lsp', -- Source: LSP
    -- 'hrsh7th/cmp-omni', -- Source: omnifunc (Disabled b/c seems redundant?)
    --

    -- 'f3fora/cmp-spell', -- Source: Spell (Disabled b/c too many completions)
    'hrsh7th/cmp-buffer', -- Source: buffer words

    'hrsh7th/cmp-emoji', -- Source: Emojis (type :)
    'max397574/cmp-greek', -- Source: Greek letters (type :)
    'chrisgrieser/cmp-nerdfont', -- Source: Nerdfont icons (type :)

    -- 'hrsh7th/cmp-cmdline', -- Source: command line completions (Disabled b/c disabled arrow and C-p)
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    cmp.setup({
      -- REQUIRED - a snippet engine must be specified
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- See :help ins-completion for why these mappings were chosen
      mapping = { -- Intentionally not using cmp.mapping.preset.insert()
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept completion. `select=false` to only confirm explicitly selected items
        -- Traditionally, vim uses <C-y> instead of <CR>
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<C-Space>'] = cmp.mapping.complete({}), -- Manually trigger completion

        -- Luasnip keybinds <C-l> moves to next (right) slot, <C-h> moves prev (left) slot
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end, { 'i', 's' }),
      },
      sources = { -- Order matters
        { name = 'calc' },
        { name = 'path' },
        { name = 'luasnip' },

        { name = 'nvim_lsp' },
        -- { name = 'omni' },

        -- { name = 'spell' },
        { name = 'buffer' },

        { name = 'emoji' },
        { name = 'greek' },
        { name = 'nerdfont' },
      },
    })

    -- -- Autocomplete search (/ and ?) mode (if `native_menu` is enabled, this won't work anymore)
    -- cmp.setup.cmdline({ '/', '?' }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'buffer' },
    --   },
    -- })
    --
    -- -- Autocomplete cmd (:) mode (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline(':', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = 'path' },
    --   }, {
    --     {
    --       name = 'cmdline',
    --       option = {
    --         ignore_cmds = { 'Man', '!' },
    --       },
    --     },
    --   }),
    -- })

    -- -- Autocomplete for git commits
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'cmp_git' },
    --   }, {
    --     { name = 'buffer' },
    --   })
    -- })
  end,
}
