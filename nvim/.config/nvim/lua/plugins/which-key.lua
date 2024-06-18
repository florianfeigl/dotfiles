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
			key_labels = {
				-- Labels für bestimmte Tasten überschreiben
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},
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
				name = "+file", -- Optionale Gruppennamen
				f = { "<cmd>Telescope find_files<cr>", "Find File" },
				g = { "<cmd>Telescope live_grep<br>", "Live Grep" },
				b = { "<cmd>Telescope buffers", "Search Buffers" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false },
				h = { "<cmd> Telescope help_tags", "Help Tags" },
				n = { "New File" }, -- Nur ein Label, ohne Mapping
			},
			["<leader>w"] = {
				name = "+window",
				v = { "<cmd>vsplit<cr>", "Vertical Split" },
				h = { "<cmd>split<cr>", "Horizontal Split" },
				w = { "<cmd>close<cr>", "Close Window" },
			},
			["<leader>g"] = {
				name = "+git",
				s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
				u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
				r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
				p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
				b = { "<cmd>Gitsigns blame_line<cr>", "Blame Line" },
			},
			["<leader>t"] = {
				name = "+terminal",
				t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
			},
			["<leader>s"] = {
				name = "+snapshot",
				c = { ":Silicon<CR>", mode = "v", "Snapshot Code" },
			},
		})
	end,
}
