return {
  'hrsh7th/nvim-cmp',
  -- Load immediately so 99 can use it (don't lazy load on InsertEnter)
  lazy = false,
  priority = 900, -- Load before most plugins
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
  },
  config = function()
    local cmp = require 'cmp'

    cmp.setup {
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert {
        -- Navigate down
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        -- Navigate up
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        -- Alternative navigation
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- Accept selected item
        ['<C-y>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        -- Cancel/close menu
        ['<C-e>'] = cmp.mapping.abort(),
        -- Scroll documentation
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      },

      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
      },
    }

    -- Setup capabilities for nvim-cmp (used by 99 plugin)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    vim.g.cmp_capabilities = capabilities
  end,
}
