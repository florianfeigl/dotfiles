-- vim-settings.lua

return {
  vim.cmd 'set expandtab',
  vim.cmd 'set tabstop=2',
  vim.cmd 'set softtabstop=2',
  vim.cmd 'set shiftwidth=2',

  vim.cmd 'set nu rnu',

  vim.cmd 'filetype plugin indent on',
  vim.cmd 'syntax enable',

  vim.cmd 'let g:vimtex_view_method = "zathura"',

  -- Custom Motion Mappings
  vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true }),
  vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true }),

  -- tmux-vim
  ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
  ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
  ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
  ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
}
