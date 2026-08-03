return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      view = "cmdline_popup",
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 80,
          height = "auto",
        },
        border = { style = "rounded" },
      },
    },
    lsp = {
      progress = { enabled = true },
      signature = { enabled = true },
      hover = { enabled = true },
    },
    messages = {
      enabled = true,
      view = "notify",
      view_warn = "notify",
      view_error = "notify",
      view_history = "messages",
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  },
}
