return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		wk.add({
			{ "<leader>b", desc = "Neo-tree", icon = { icon = " ", color = "orange" } },
			{ "<leader>c", group = "Code" },
			{ "<leader>s", group = "Search" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Harpoon", icon = "󰛢 " },
			{ "<leader>l", group = "Lazy", icon = { icon = " ", color = "yellow" } },
			{ "<leader>t", group = "Terminal", icon = { icon = "󰨊 ", color = "grey" } },
			{ "<leader>x", group = "Trouble", icon = { icon = " ", color = "red" } },
			{ "<leader>z", group = "Zen", icon = { icon = "󱅻 ", color = "cyan" } },
		})
	end,
}
