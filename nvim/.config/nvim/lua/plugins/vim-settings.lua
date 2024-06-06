-- vim-settings.lua

return {
  vim.cmd 'set expandtab',
  vim.cmd 'set tabstop=2',
  vim.cmd 'set softtabstop=2',
  vim.cmd 'set shiftwidth=2',

  vim.cmd 'set nu rnu',

  -- Custom Mappings
  vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true }),
  vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
}
