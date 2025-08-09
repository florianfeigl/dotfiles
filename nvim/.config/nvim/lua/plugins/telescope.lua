-- plugins/telescope.lua

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<C-h>"] = "which_key" },
            n = { ["<C-h>"] = "which_key" },
          },
        },
      })

      -- deine Keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })
      telescope.load_extension("ui-select")
    end,
  },
}
