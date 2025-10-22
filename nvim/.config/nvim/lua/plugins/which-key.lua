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
        delay = function(ctx)
          if ctx.plugin then
            return 0
          end
          if ctx.keys == "<leader>" or ctx.keys == "<localleader>" then
            return 0
          end
          return 200
        end,
        show_help = true,
        triggers = {
          { "<leader>", mode = "n" },
          { "<leader>", mode = "v" },
          { "<localleader>", mode = "n" },
          { "<localleader>", mode = "v" },
        },
      })

      local function telescope_builtin(name)
        return function()
          require("telescope.builtin")[name]()
        end
      end

      local function with_snacks(callback)
        return function(...)
          local ok, snacks = pcall(require, "snacks")
          if not ok then
            vim.notify("Snacks is not available", vim.log.levels.WARN)
            return
          end
          return callback(snacks, ...)
        end
      end

      local snack_toggles = {}

      local function toggle_handle(name, creator)
        return with_snacks(function(snacks)
          snack_toggles[name] = snack_toggles[name] or creator(snacks)
          snack_toggles[name]:toggle()
        end)
      end

      wk.add({
        { "<C-n>", "<cmd>Neotree filesystem toggle left<CR>", desc = "Neotree Toggle", mode = "n" },
        {
          "<c-/>",
          with_snacks(function(snacks)
            snacks.terminal()
          end),
          desc = "Toggle Terminal",
          mode = { "n", "t" },
        },
        {
          "<c-_>",
          with_snacks(function(snacks)
            snacks.terminal()
          end),
          desc = "Toggle Terminal",
          mode = { "n", "t" },
        },
        {
          "]]",
          with_snacks(function(snacks)
            snacks.words.jump(vim.v.count1)
          end),
          desc = "Next Reference",
          mode = { "n", "t" },
        },
        {
          "[[",
          with_snacks(function(snacks)
            snacks.words.jump(-vim.v.count1)
          end),
          desc = "Prev Reference",
          mode = { "n", "t" },
        },
      }, { silent = true })

      wk.add({
        { "<leader>f", group = "file" },
        { "<leader>ff", telescope_builtin("find_files"), desc = "Find File" },
        { "<leader>fg", telescope_builtin("live_grep"), desc = "Live Grep" },
        { "<leader>fb", telescope_builtin("buffers"), desc = "Search Buffers" },
        { "<leader>fh", telescope_builtin("help_tags"), desc = "Help Tags" },
        { "<leader>fr", telescope_builtin("oldfiles"), desc = "Open Recent File" },
        {
          "<leader>gf",
          function()
            vim.lsp.buf.format({ async = true })
          end,
          desc = "Format File",
        },
      }, { silent = true })

      wk.add({
        { "<leader>b", group = "buffer" },
        {
          "<leader>bd",
          with_snacks(function(snacks)
            snacks.bufdelete()
          end),
          desc = "Delete Buffer",
        },
      }, { silent = true })

      wk.add({
        { "<leader>c", group = "code" },
        {
          "<leader>cR",
          with_snacks(function(snacks)
            snacks.rename.rename_file()
          end),
          desc = "Rename File",
        },
      }, { silent = true })

      wk.add({
        { "<leader>g", group = "git" },
        {
          "<leader>gB",
          with_snacks(function(snacks)
            snacks.gitbrowse()
          end),
          desc = "Git Browse",
        },
        {
          "<leader>gb",
          with_snacks(function(snacks)
            snacks.git.blame_line()
          end),
          desc = "Git Blame Line",
        },
        {
          "<leader>gg",
          with_snacks(function(snacks)
            snacks.lazygit()
          end),
          desc = "Lazygit",
        },
        {
          "<leader>gl",
          with_snacks(function(snacks)
            snacks.lazygit.log()
          end),
          desc = "Lazygit Log (cwd)",
        },
      }, { silent = true })

      wk.add({
        { "<leader>s", group = "snapshot" },
        { "<leader>sc", "<cmd>Silicon<CR>", desc = "Snapshot Code", mode = "v" },
        {
          "<leader>.",
          with_snacks(function(snacks)
            snacks.scratch()
          end),
          desc = "Toggle Scratch Buffer",
        },
        {
          "<leader>S",
          with_snacks(function(snacks)
            snacks.scratch.select()
          end),
          desc = "Select Scratch Buffer",
        },
      }, { silent = true })

      wk.add({
        { "<leader>t", group = "terminal" },
        {
          "<leader>tt",
          with_snacks(function(snacks)
            snacks.terminal()
          end),
          desc = "Toggle Terminal",
        },
      }, { silent = true })

      wk.add({
        {
          "<leader>n",
          with_snacks(function(snacks)
            snacks.notifier.show_history()
          end),
          desc = "Notification History",
        },
        {
          "<leader>un",
          with_snacks(function(snacks)
            snacks.notifier.hide()
          end),
          desc = "Dismiss Notifications",
        },
        {
          "<leader>N",
          with_snacks(function(snacks)
            snacks.win({
              file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
              width = 0.6,
              height = 0.6,
              wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              },
            })
          end),
          desc = "Neovim News",
        },
      }, { silent = true })

      wk.add({
        { "<leader>w", group = "window" },
        { "<leader>wh", "<cmd>split<CR>", desc = "Horizontal Split" },
        { "<leader>wv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
        { "<leader>ww", "<cmd>close<CR>", desc = "Close Window" },
      }, { silent = true })

      wk.add({
        {
          "<leader>V",
          with_snacks(function(snacks)
            snacks.explorer()
          end),
          desc = "File Explorer",
        },
      }, { silent = true })

      wk.add({
        { "<leader>u", group = "ui toggles" },
        {
          "<leader>us",
          toggle_handle("spell", function(snacks)
            return snacks.toggle.option("spell", { name = "Spelling" })
          end),
          desc = "Toggle Spelling",
        },
        {
          "<leader>uw",
          toggle_handle("wrap", function(snacks)
            return snacks.toggle.option("wrap", { name = "Wrap" })
          end),
          desc = "Toggle Wrap",
        },
        {
          "<leader>uL",
          toggle_handle("relativenumber", function(snacks)
            return snacks.toggle.option("relativenumber", { name = "Relative Number" })
          end),
          desc = "Toggle Relative Number",
        },
        {
          "<leader>ud",
          toggle_handle("diagnostics", function(snacks)
            return snacks.toggle.diagnostics()
          end),
          desc = "Toggle Diagnostics",
        },
        {
          "<leader>ul",
          toggle_handle("line_number", function(snacks)
            return snacks.toggle.line_number()
          end),
          desc = "Toggle Line Number",
        },
        {
          "<leader>uc",
          toggle_handle("conceallevel", function(snacks)
            return snacks.toggle.option("conceallevel", {
              off = 0,
              on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
            })
          end),
          desc = "Toggle Conceal",
        },
        {
          "<leader>uT",
          toggle_handle("treesitter", function(snacks)
            return snacks.toggle.treesitter()
          end),
          desc = "Toggle Treesitter",
        },
        {
          "<leader>ub",
          toggle_handle("background", function(snacks)
            return snacks.toggle.option("background", {
              off = "light",
              on = "dark",
              name = "Dark Background",
            })
          end),
          desc = "Toggle Background",
        },
        {
          "<leader>uh",
          toggle_handle("inlay_hints", function(snacks)
            return snacks.toggle.inlay_hints()
          end),
          desc = "Toggle Inlay Hints",
        },
      }, { silent = true })
    end,
  },
  {
    "nvim-mini/mini.nvim",
    version = "*",
    config = function()
      local comment = require("mini.comment")
      comment.setup({
        mappings = {
          comment = "gc",
          comment_visual = "gc",
          comment_line = "",
          textobject = "gc",
        },
      })

      vim.keymap.set(
        "n",
        "<leader>/",
        function()
          return comment.operator() .. "_"
        end,
        { expr = true, desc = "Toggle Line Comment" }
      )
      vim.keymap.set(
        "x",
        "<leader>/",
        function()
          return comment.operator()
        end,
        { expr = true, desc = "Toggle Comment Selection" }
      )
    end,
  },
}
