-- plugins/snacks.lua (screenshots, scratchpads, toggles)

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    terminal = { enabled = true },
    explorer = {
      enabled = true,
      width = 40,
      side = "left",
      -- extra options: theme, hide_dotfiles, etc.
    },
    image = {
      enabled = true,
      backend = "kitty",
      max_width = 800,
    },
    input = {
      enabled = true,
      -- you can override border style, icons, etc.
    },
    lazygit = { enabled = true },
    picker = {
      enabled = true,
      -- choose backend: "telescope", "fzf-lua", or Snacks' native picker
      backend = "telescope",
      layout = "vertical",
    },
    scope = { enabled = true },
    scroll = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
  end,
}
