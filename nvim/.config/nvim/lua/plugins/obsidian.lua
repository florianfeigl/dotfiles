-- obsidian.lua

return {
  'epwalsh/obsidian.nvim',
  version = "*",
  lazy = true,
  ft = markdown,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require("obsidian").setup({
      dir = "~/src/Grive/Repositories/vaults",  -- Ändere den Pfad zu deinem Obsidian-Vault
      completion = {
        nvim_cmp = true,  -- Falls du nvim-cmp für die Autovervollständigung verwendest
      },
      daily_notes = {
        folder = "daily",  -- Optional: Ordner für tägliche Notizen
      },
    })
  end
}

--  opts = {
--    workspaces = {
--      {
--        name = "personal",
--        path = "~/src/Grive/Repositories/vaults/personal",
--      },
--      {
--        name = "work",
--        path = "~/src/Grive/Repositories/vaults/work",
--      },
--    },
