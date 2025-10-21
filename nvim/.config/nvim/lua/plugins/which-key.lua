-- lua/plugins/which-key.lua

return {
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {},
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 600
    end,
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        show_help = true,
        triggers = { "auto" },
      })

      -- Keymappings
      wk.add({
        {
          { "<leader>f",  group = "file" },
          {
            "<leader>gf",
            function()
              vim.lsp.buf.format({ async = true })
            end,
            desc = "Format File",
          },
          { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Search Buffers" },
          { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find File" },
          { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live Grep" },
          { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help Tags" },
          { "<leader>fr", "<cmd>Telescope oldfiles<CR>",   desc = "Open Recent File", remap = true },
          { "<leader>s",  group = "snapshot" },
          { "<leader>t",  group = "terminal" },
          "<leader>tt",
          function()
            Snacks.terminal()
          end,
          desc = "Toggle Terminal",
        },
        { "<leader>w",  group = "window" },
        { "<leader>wh", "<cmd>split<CR>",   desc = "Horizontal Split" },
        { "<leader>wv", "<cmd>vsplit<CR>",  desc = "Vertical Split" },
        { "<leader>ww", "<cmd>close<CR>",   desc = "Close Window" },
        { "<leader>sc", "<cmd>Silicon<CR>", desc = "Snapshot Code",   mode = "v" },
      })
    end,
  },
  {
    -- mini.icons
    "echasnovski/mini.icons",
  },
}
