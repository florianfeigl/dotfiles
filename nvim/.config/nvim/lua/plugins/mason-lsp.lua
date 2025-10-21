-- ~/.config/nvim/lua/plugins/mason-lsp.lua
return {
  ---------------------------------------------------------------------------
  -- Mason core
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- Mason‑LSPconfig (auto‑installs language servers)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "html",
          "cssls",
          "sqls",
          "ansiblels",
        },
        automatic_installation = true,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Core LSP setup, using vim.lsp.config (Neovim ≥ 0.11)
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local util = require("lspconfig.util")

      -- nvim‑cmp capabilities
      local ok_cmp, cmp_caps = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_cmp then
        capabilities = cmp_caps.default_capabilities(capabilities)
      end

      -----------------------------------------------------------------------
      -- gopls
      -----------------------------------------------------------------------
      local function go_module_path(dir)
        local gomod = util.path.join(dir, "go.mod")
        local f = io.open(gomod, "r")
        if not f then
          return nil
        end
        local content = f:read("*a")
        f:close()
        return content:match("^module%s+([%w%p%-_/%.]+)")
      end

      vim.lsp.config.gopls = {
        capabilities = capabilities,
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = { gofumpt = true, staticcheck = true },
        },
        on_new_config = function(cfg, root)
          local mod = go_module_path(root or "")
          if mod then
            cfg.settings = cfg.settings or {}
            cfg.settings.gopls = cfg.settings.gopls or {}
            cfg.settings.gopls["formatting.local"] = mod
          end
        end,
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false, name = "gopls" })
            end,
          })
        end,
      }

      -----------------------------------------------------------------------
      -- Other servers
      -----------------------------------------------------------------------
      local servers = {
        lua_ls = {
          capabilities = capabilities,
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        },
        pyright = { capabilities = capabilities },
        rust_analyzer = { capabilities = capabilities },
        html = { capabilities = capabilities },
        cssls = { capabilities = capabilities },
        sqls = { capabilities = capabilities },
        ansiblels = { capabilities = capabilities },
      }
      for name, conf in pairs(servers) do
        vim.lsp.config[name] = conf
      end

      -----------------------------------------------------------------------
      -- Enable all configured servers
      -----------------------------------------------------------------------
      for name in pairs(servers) do
        pcall(vim.lsp.enable, name)
      end
      pcall(vim.lsp.enable, "gopls")

      -----------------------------------------------------------------------
      -- Utility: smart formatter and keymaps
      -----------------------------------------------------------------------
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

      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          local o = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, o)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, o)
          vim.keymap.set("n", "<C-i>", vim.lsp.buf.signature_help, o)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, o)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, o)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, o)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
          vim.keymap.set(
            "n",
            "<leader>fF",
            format_smart,
            vim.tbl_extend("force", o, { desc = "Format File" })
          )
        end,
      })
    end,
  },
}
