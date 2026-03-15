-- plugins/catppuccin.lua

return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
			})
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
