return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',

  -- Use the 'opts' key to pass this table to the setup function
  opts = {
    ensure_installed = {
      "javascript", "tsx", "typescript", "c", "lua", "vim", "vimdoc", "query",
      "markdown", "markdown_inline", "html", "css", "ruby"
    },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- auto_install = false, -- Recommended for a predictable setup
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    -- You can also configure other modules here, for example:
    indent = {
      enable = true,
    },
  },

  -- The config function now only needs to run if you have logic
  -- that CANNOT be handled by `opts`. In this case, it's not needed,
  -- but is kept here for demonstration.
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}

