-- plugins/none-ls.lua
return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Lua / Python / Web
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier, -- formatiert auch JS/TS/TSX/JSX/Astro (wenn Prettier‑Plugin vorhanden)
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				-- optional (wenn du willst):
				-- null_ls.builtins.diagnostics.eslint_d,
				-- null_ls.builtins.code_actions.eslint_d,
			},
		})

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = {
				"*.go",
				"*.lua",
				"*.py",
				"*.ts",
				"*.js",
				"*.tsx",
				"*.jsx",
				"*.astro", -- NEU: Astro
			},
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
