return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>td",
      "<cmd>TodoQuickFix<cr>",
      desc = "TODO: QuickFix List",
    },
    {
      "<leader>tt",
      "<cmd>TodoTelescope<cr>",
      desc = "TODO: QuickFix Telescope",
    },
    {
      "<leader>to",
      "<cmd>TodoTrouble<cr>",
      desc = "TODO: Open in Trouble",
    },
    {
      "<leader>th",
      function()
        local ok, Config = pcall(require, "todo-comments.config")
        if not ok or not Config.options then
          vim.notify("todo-comments not loaded", vim.log.levels.WARN)
          return
        end
        local lines = {}
        for tag, opts in pairs(Config.options.keywords) do
          local alt = opts.alt and #opts.alt > 0 and ("  (also " .. table.concat(opts.alt, ", ") .. ")") or ""
          table.insert(lines, tag .. ":" .. alt)
        end
        table.sort(lines)
        vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Todo keywords" })
      end,
      desc = "TODO: Show keywords",
    },
  },
}
