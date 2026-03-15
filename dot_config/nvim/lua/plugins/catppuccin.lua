-- plugins/catppuccin.lua

return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				dim_inactive = {
					enabled = false,
				},
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
			})
			-- Apply the colorscheme immediately
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"LazyVim/LazyVim",
		lazy = true,
		priority = 50,
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
