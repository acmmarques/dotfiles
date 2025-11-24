return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Neotree" },
  keys = {
    {
      "<leader>b",
      function()
        require("neo-tree.command").execute({ toggle = true, source = "filesystem" })
      end,
      desc = "Toggle Neo-tree",
    },
  },
  opts = {
    -- All your previous options are preserved
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
    window = {
      position = "left",
      width = 40,
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
  -- This is the corrected config function
  config = function(_, opts)
    -- This ensures the plugin is set up with your options
    require("neo-tree").setup(opts)

    -- Open Neotree if nvim is opened on a directory or with no files
    vim.api.nvim_create_autocmd("VimEnter", {
      desc = "Open Neotree on startup",
      group = vim.api.nvim_create_augroup("autocmd-neotree-startup", { clear = true }),
      callback = function(event)
        -- Check if nvim was opened without a file argument
        -- This covers `nvim` and `nvim .`
        if event.file == "" then
          vim.cmd("Neotree")
        end
      end,
    })
  end,
}

