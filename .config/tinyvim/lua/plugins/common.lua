return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = require("plugins.configs.snacks"),
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		opts = require("plugins.configs.telescope"),
	},
}
