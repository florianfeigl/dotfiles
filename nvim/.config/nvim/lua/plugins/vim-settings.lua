-- plugins/vim-settings.lua
return {
  {
    -- Dummy-Host für Settings (früh laden)
    "nvim-lua/plenary.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Leader sehr früh (wichtig für <leader>…)
      vim.g.mapleader = " "

      -- Indentation & Numbers
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.number = true
      vim.opt.relativenumber = true

      vim.cmd([[syntax enable]])
      vim.cmd([[filetype plugin indent on]])

      -- Motions
      vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

      -- tmux-navigator (falls Plugin aktiv ist)
      vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  { noremap = true, silent = true })
      vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>",  { noremap = true, silent = true })
      vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>",    { noremap = true, silent = true })
      vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { noremap = true, silent = true })

      -- Eingabeverzögerung etwas erhöhen (Leader-Kombos mit Shift)
      vim.o.timeout = true
      vim.o.timeoutlen = 600
    end,
  },
}
