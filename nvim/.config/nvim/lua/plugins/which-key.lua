-- lua/plugins/which-key.lua

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {},
	config = function()
		local wk = require("which-key")

		wk.setup({
			plugins = {
				marks = true, -- Zeigt eine Liste Ihrer Marks an
				registers = true, -- Zeigt Ihre Register an
				spelling = {
					enabled = true, -- Zeigt Vorschläge an, wenn Sie z= drücken
					suggestions = 20, -- Wie viele Vorschläge gezeigt werden sollen
				},
			},
			operators = { gc = "Kommentare" },
			icons = {
				breadcrumb = "»", -- Symbol für Breadcrumbs
				separator = "➜", -- Symbol zwischen Taste und Label
				group = "+", -- Symbol vor Gruppen
			},
			window = {
				border = "none", -- Randstil: none, single, double, shadow
				position = "bottom", -- Position des Fensters: bottom, top
				margin = { 1, 0, 1, 0 }, -- Fensterrand
				padding = { 2, 2, 2, 2 }, -- Fensterabstand
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- Mindest- und Maximalhöhe der Spalten
				width = { min = 20, max = 50 }, -- Mindest- und Maximalbreite der Spalten
				spacing = 3, -- Abstand zwischen den Spalten
				align = "left", -- Ausrichtung der Spalten: left, center, right
			},
			ignore_missing = false, -- Blendet nicht definierte Mappings aus
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- Blendet Boilerplate-Mappings aus
			show_help = true, -- Zeigt Hilfemeldung an, wenn das Popup sichtbar ist
			triggers = "auto", -- Automatische Auslösung
		})

		-- Keymappings
		wk.register({
			["<leader>f"] = {
				name = "+file",
				f = { "<cmd>Telescope find_files<CR>", "Find File" },
				g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
				b = { "<cmd>Telescope buffers<CR>", "Search Buffers" },
				r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File", noremap = false },
				h = { "<cmd> Telescope help_tags<CR>", "Help Tags" },
				-- x = { "New File" }, -- Nur ein Label, ohne Mapping
			},
			["<leader>w"] = {
				name = "+window",
				v = { "<cmd>vsplit<CR>", "Vertical Split" },
				h = { "<cmd>split<CR>", "Horizontal Split" },
				w = { "<cmd>close<CR>", "Close Window" },
			},
			--			["<leader>g"] = {
			--				name = "+git",
			--				s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
			--				u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk" },
			--				r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
			--				p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk" },
			--				b = { "<cmd>Gitsigns blame_line<CR>", "Blame Line" },
			--			},
			["<leader>t"] = {
				name = "+terminal",
				t = { "<cmd>ToggleTerm<CR>", "Toggle Terminal" },
			},
			["<leader>s"] = {
				name = "+snapshot",
				c = { "<cmd>:Silicon<CR>", mode = "v", "Snapshot Code" },
			},
		})
	end,
}
