-- plugins/none-ls.lua

return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Lua / Python / Web
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
		})

		-- Format per Taste
		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ async = false })
		end, { desc = "Format buffer" })

		-- Format on save (empfohlen)
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.lua", "*.py", "*.ts", "*.js", "*.tsx", "*.jsx" },
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
