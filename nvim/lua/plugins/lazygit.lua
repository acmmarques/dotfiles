return {
  'kdheepak/lazygit.nvim',
  config = function()
    -- Create a user command for LazyGit
    vim.api.nvim_create_user_command('Lg', 'LazyGit', {})

    -- Set keymap for LazyGit using vim.keymap.set
    vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', { noremap = true, silent = true })
  end
}

