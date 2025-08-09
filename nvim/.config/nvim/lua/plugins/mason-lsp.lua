-- plugins/mason-lsp-config.lua
return {
  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-LSPconfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "html",
          "cssls",
          "sqlls",
          "arduino_language_server",
          -- "clangd",
        },
        automatic_installation = true,
      })
    end,
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Capabilities (nvim-cmp optional)
      local ok_cmp, cmp_caps = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_cmp then
        capabilities = cmp_caps.default_capabilities(capabilities)
      end

      -- Smart formatter: Lua bevorzugt null-ls (Stylua)
      local function format_smart()
        vim.lsp.buf.format({
          async = false,
          filter = function(client)
            if vim.bo.filetype == "lua" then
              return client.name == "null-ls"
            end
            return true
          end,
        })
      end

      -- Modulpfad aus go.mod (für gopls formatting.local)
      local function go_module_path(dir)
        local gomod = util.path.join(dir, "go.mod")
        local f = io.open(gomod, "r")
        if not f then return nil end
        local content = f:read("*a"); f:close()
        return content:match("^module%s+([%w%p%-_/%.]+)")
      end

      -- ===== gopls =====
      lspconfig.gopls.setup({
        capabilities = capabilities,
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          },
        },
        on_new_config = function(new_config, new_root_dir)
          local mod = go_module_path(new_root_dir or "")
          if mod then
            new_config.settings = new_config.settings or {}
            new_config.settings.gopls = new_config.settings.gopls or {}
            new_config.settings.gopls["formatting.local"] = mod
          end
        end,
        on_attach = function(client, bufnr)
          -- Semantic tokens fallback (ohne LazyVim)
          if not client.server_capabilities.semanticTokensProvider then
            local caps = client.config
              and client.config.capabilities
              and client.config.capabilities.textDocument
              and client.config.capabilities.textDocument.semanticTokens
            if caps then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = caps.tokenTypes or {},
                  tokenModifiers = caps.tokenModifiers or {},
                },
                range = true,
              }
            end
          end

          -- Go: Format on save via gopls
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false, name = "gopls" })
            end,
          })
        end,
      })

      -- ===== übrige Server =====
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        pyright = {},
        rust_analyzer = {},
        html = {},
        cssls = {},
        sqlls = {},
        arduino_language_server = {},
        -- clangd = {},
      }
      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        lspconfig[name].setup(opts)
      end

      -- ===== Globale Diagnostics-Keymaps =====
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      -- ===== Buffer-lokale LSP-Keymaps =====
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-i>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- Einheitliches Format-Shortcut
          vim.keymap.set("n", "<leader>fF", format_smart, vim.tbl_extend("force", opts, { desc = "Format File" }))
        end,
      })
    end,
  },
}
