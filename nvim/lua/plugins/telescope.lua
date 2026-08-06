return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		pcall(telescope.load_extension, "fzf")

		vim.keymap.set("n", "<leader> ", builtin.find_files, { desc = "Telescope: Find files" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope: Buffers" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope: Help tags" })
		vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Telescope: Recent files" })
		vim.keymap.set("n", "<leader>sg", builtin.git_status, { desc = "Telescope: Git status" })
		vim.keymap.set("n", "<leader>s ", builtin.live_grep, { desc = "Telescope: Live grep" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Telescope: Resume last picker" })
		vim.keymap.set("n", "<C-g>", builtin.git_files, { desc = "Telescope: Git files" })
		vim.keymap.set("n", "<leader>sp", function()
			vim.opt.clipboard = "unnamedplus"
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Telescope: Grep prompt" })
	end,
}
