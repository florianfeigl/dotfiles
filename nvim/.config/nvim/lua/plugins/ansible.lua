return {
	{
		"arouene/vim-ansible-vault",
		ft = { "yaml", "ansible" },
		config = function()
			local ok, wk = pcall(require, "which-key")
			if not ok then
				return
			end

			local password_file = vim.fn.expand("~/.vault_password")
			vim.g.ansible_vault_password_file = password_file
			vim.env.ANSIBLE_VAULT_PASSWORD_FILE = password_file

			local function register(buf)
				wk.add({
					{ "<leader>av", "<cmd>AnsibleVault<CR>", desc = "AnsibleVault" },
					{ "<leader>au", "<cmd>AnsibleUnvault<CR>", desc = "AnsibleUnvault" },
				}, { buffer = buf })
			end

			register(vim.api.nvim_get_current_buf())

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("AnsibleVaultWhichKey", { clear = true }),
				pattern = { "yaml", "ansible" },
				callback = function(args)
					register(args.buf)
				end,
			})
		end,
	},
}
