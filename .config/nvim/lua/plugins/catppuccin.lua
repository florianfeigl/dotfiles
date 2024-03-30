-- catppuccin.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function ()
    
    require('catppuccin').setup {
      flavour = "mocha",
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = true,
      show_end_of_buffer = true,
      term_colors = false,
      dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
      },
    }
    -- plugin call
    vim.cmd.colorscheme 'catppuccin'
  end
}

