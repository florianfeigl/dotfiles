return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {},
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
