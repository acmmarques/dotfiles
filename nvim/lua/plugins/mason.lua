return {
  "mason-org/mason.nvim",
  opts = {
    npm = {
      -- Override the user's global policy so Mason can install newly released packages.
      install_args = { "--min-release-age=0" },
    },
  },
}
