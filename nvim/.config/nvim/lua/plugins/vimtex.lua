-- plugins/vimtex.lua

return {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_view_method = "zathura" -- Use Zathura for PDF preview
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "build", -- Use a separate build directory for output files
    }
    vim.g.vimtex_view_general_options = "--synctex-forward @line:@col:@file"
    vim.cmd([[
        let g:vimtex_view_general_options_latexmk = '--synctex-editor-command "nvr --remote-silent +%l %f"'
        ]])
  end,
  ft = 'tex',  -- Lade das Plugin nur für TeX-Dateien
}
