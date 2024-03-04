return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'pyright', 'rust_analyzer', 'sqlls', 'html' },
      }
    end,
  },

  {
  'neovim/nvim-lspconfig',
  config = function()
    -- Switch for controlling whether you want autoformatting.
    --  Use :KickstartFormatToggle to toggle autoformatting on or off
    local format_is_enabled = true
    vim.api.nvim_create_user_command('AutoformatToggle', function()
      format_is_enabled = not format_is_enabled
      print('Setting autoformatting to: ' .. tostring(format_is_enabled))
    end, {})

    -- Create an augroup that is used for managing our formatting autocmds.
    --      We need one augroup per client to make sure that multiple clients
    --      can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = 'kickstart-lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    --
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Tsserver usually works poorly. Sorry you work with bad languages
        -- You can remove this line if you know what you're doing :)
        if client.name == 'tsserver' then
          return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              return
            end

            vim.lsp.buf.format {
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            }
          end,
        })
      end,
    })
  end,
  },
--  {
--    'neovim/nvim-lspconfig',
--    config = function()
--      local lspconfig = require 'lspconfig'
--      lspconfig.lua_ls.setup {}
--      lspconfig.pyright.setup {}
--      lspconfig.rust_analyzer.setup {}
--      lspconfig.sqlls.setup {}
--      lspconfig.html.setup {}
--      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = '[K] LSP buffer hover' })
--      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]o to [D]efinition' })
--      vim.keymap.set('n', 'V', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
--
--      vim.api.nvim_create_autocmd('LspAttach', {
--        callback = function(args)
--          local bufnr = args.buf
--          local client = vim.lsp.get_client_by_id(args.data.client_id)
--          if client.server_capabilities.completionProvider then
--            vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
--          end
--          if client.server_capabilities.definitionProvider then
--            vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
--          end
--        end,
--      })
--    end,
--  },
  {
    -- Useful status updates for LSP
    'j-hui/fidget.nvim',
    opts = {},
  },
  {
    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
}
