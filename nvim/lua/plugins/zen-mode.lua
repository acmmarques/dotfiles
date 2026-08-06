local neotree_open = false

return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen: Toggle zen mode" },
  },
  dependencies = { "folke/twilight.nvim" },
  opts = {
    window = {
      width = 120,
      backdrop = 0.95,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        foldcolumn = "0",
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = true },
    },
    on_open = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].ft == "neo-tree" then
          neotree_open = true
          break
        end
      end
      if neotree_open then
        vim.cmd("Neotree close")
      end
      pcall(vim.cmd, "Markview disable")
    end,
    on_close = function()
      if neotree_open then
        vim.cmd("Neotree")
      end
      neotree_open = false
      pcall(vim.cmd, "Markview enable")
    end,
  },
}
