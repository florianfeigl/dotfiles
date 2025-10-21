return {
  {
    "arouene/vim-ansible-vault",
    ft = { "yaml", "ansible" },
    config = function()
      --      vim.g.vault_password_file = "~/.vault_pass.txt"
      vim.keymap.set("n", "<leader>av", ":AnsibleVault<CR>", { desc = "Encrypt vault" })
      vim.keymap.set("n", "<leader>au", ":AnsibleUnvault<CR>", { desc = "Decrypt vault" })
    end,
  },
}
