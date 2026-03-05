-- plugins/vimtex.lua

return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_general_viewer = "zathura"
		vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
		vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_view_zathura_disable_autofocus = 1
	end,
}
