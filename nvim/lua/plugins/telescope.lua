return {
        'nvim-telescope/telescope.nvim',
        config = function()
		local telescope = require('telescope')
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader> ', builtin.find_files, {})
                vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
                vim.keymap.set('n', '<C-g>', builtin.git_files, {})
                vim.keymap.set('n', '<leader>gr', function()
                        vim.opt.clipboard = 'unnamedplus'
                        builtin.grep_string({ search = vim.fn.input("Grep > ") })
                end)
	end
}
