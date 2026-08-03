return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d", "eslint" },
      javascriptreact = { "eslint_d", "eslint" },
      typescript = { "eslint_d", "eslint" },
      typescriptreact = { "eslint_d", "eslint" },
      python = { "ruff" },
      lua = { "selene", "luacheck" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      ruby = { "rubocop" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
        lint.try_lint("cspell")
      end,
    })
  end,
}
