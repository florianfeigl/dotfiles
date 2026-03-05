-- plugins/catppuccin.lua

return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				-- configurations
			})
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
