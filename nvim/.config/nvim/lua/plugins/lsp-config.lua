-- plugins/lsp-config.lua

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"rust_analyzer",
					"html",
					"cssls",
					"sqlls",
          "arduino_language_server",
--          "clangd",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
			})
			lspconfig.sqlls.setup({
				capabilities = capabilities,
			})
--			lspconfig.clangd.setup({
--				capabilities = capabilities,
--			})

			-- Global mappings.
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-i>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<space>fF", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
				end,
			})
		end,
	},
}
