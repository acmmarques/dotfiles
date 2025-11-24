return {
        'VonHeikemen/fine-cmdline.nvim',
        requires = {'MunifTanjim/nui.nvim'},
        config = function()
                vim.api.nvim_set_keymap('n', '<CR>', '<cmd>FineCmdline<CR>', {noremap = true})
                vim.api.nvim_set_keymap('n', '<leader><CR>', '<cmd>FineCmdline<CR>', {noremap = true})
        end
}
