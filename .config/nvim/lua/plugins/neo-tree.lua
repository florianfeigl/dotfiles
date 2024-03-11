return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  keys = {
    { '<C-p>', '<cmd>Neotree toggle<cr>', desc = '[F]iles with Neotree' },
  },
  confg = function()
    require('neo-tree').setup {
      opts = {
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
        },
      },
    }
  end,
}
