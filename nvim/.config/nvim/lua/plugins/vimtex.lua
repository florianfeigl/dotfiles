-- plugins/vimtex.lua

return {
    'lervag/vimtex',
    config = function()
      vim.g.vimtex_view_method = 'zathura'  -- Setze deinen bevorzugten PDF-Viewer
      vim.g.vimtex_compiler_method = 'latexmk'  -- Verwende latexmk zum Kompilieren
    end,
    ft = 'tex',  -- Lade das Plugin nur für TeX-Dateien
  }
