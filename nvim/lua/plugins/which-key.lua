return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Telescope", icon = " " },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon", icon = "󰛢 " },
      { "<leader>t", group = "Todo", icon = " " },
      { "<leader>l", group = "Lazy", icon = "󰂱 " },
      { "<leader>x", group = "Trouble", icon = " " },
    })
  end,
}
