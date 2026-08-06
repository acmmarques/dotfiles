return {
	"ThePrimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon: Toggle menu" })

		vim.keymap.set("n", "<C-u>", function()
			ui.nav_prev()
		end, { desc = "Harpoon: Previous file" })
		vim.keymap.set("n", "<C-i>", function()
			ui.nav_next()
		end, { desc = "Harpoon: Next file" })
	end,
}
