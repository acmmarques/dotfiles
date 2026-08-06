return {
  "folke/twilight.nvim",
  cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
  keys = {
    { "<leader>zt", "<cmd>Twilight<cr>", desc = "Zen: Toggle twilight dimming" },
  },
  opts = {
    dimming = {
      alpha = 0.35,
      color = { "Normal", "#ffffff" },
      inactive = false,
    },
    context = 15,
    treesitter = true,
    expand = {
      "function",
      "method",
      "table",
      "if_statement",
      "class",
      "repeat",
    },
  },
}
