-- plugins/treesitter.lua

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "html", "python", "rust", "css", "sql" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
