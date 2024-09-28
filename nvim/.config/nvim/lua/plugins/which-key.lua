-- lua/plugins/which-key.lua

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
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
        triggers = {"auto"},
      })

      -- Keymappings
      wk.add({
        {
          { "<leader>f", group = "file" },
          { "<leader>fF", desc = "Format File" },
          { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Search Buffers" },
          { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find File" },
          { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
          { "<leader>fh", "<cmd> Telescope help_tags<CR>", desc = "Help Tags" },
          { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Open Recent File", remap = true },
          { "<leader>s", group = "snapshot" },
          { "<leader>t", group = "terminal" },
          { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
          { "<leader>w", group = "window" },
          { "<leader>wh", "<cmd>split<CR>", desc = "Horizontal Split" },
          { "<leader>wv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
          { "<leader>ww", "<cmd>close<CR>", desc = "Close Window" },
          { "<leader>sc", "<cmd>:Silicon<CR>", desc = "Snapshot Code", mode = "v" },
          { "<leader>c", group = "ChatGPT" },
          { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
          { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
          { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
          { "<leader>ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
          { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
          { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
          { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
          { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
          { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
          { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
          { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
          { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
          { "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" } },
        },
      })
    end,
  },
  {
    -- mini.icons
    "echasnovski/mini.icons",
  },
}
