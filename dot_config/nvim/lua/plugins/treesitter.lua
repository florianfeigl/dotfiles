-- plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter.configs not found, skipping config", vim.log.levels.WARN)
        return
      end
      
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "html", "python", "rust", "css", "sql", "go", "gomod", "gowork", "gosum" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
}
