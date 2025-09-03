-- ~/.config/nvim-new/plugin/plugins.lua
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-space>"] = {},
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-n>"] = { "select_and_accept" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "scroll_documentation_up", "fallback" },
		["<C-l>"] = { "snippet_forward", "fallback" },
		["<C-h>"] = { "snippet_backward", "fallback" },
		-- ["<C-e>"] = { "hide" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	cmdline = {
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},

	sources = { default = { "lsp" } },
})

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "^v0.10.0" },
})
vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

-- vim.pack.add({
-- 	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },
-- 	-- deps
-- 	"nvim-lua/plenary.nvim",
-- 	"MunifTanjim/nui.nvim",
-- 	"nvim-tree/nvim-web-devicons",
-- })
--
-- local status_ok, neotree = pcall(require, "neo-tree")
-- if not status_ok then
-- 	vim.notify("Neo-tree not found!")
-- 	return
-- end
-- neotree.setup()

vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim", version = "^v3.17.0" },
})

local wk = require("which-key")
wk.setup({
	preset = "helix",
	defaults = {},
	spec = {
		{
			mode = { "n", "v" },
			{ "<leader><tab>", group = "tabs" },
			{ "<leader>c", group = "code" },
			{ "<leader>d", group = "debug" },
			{ "<leader>dp", group = "profiler" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>g", group = "git" },
			{ "<leader>gh", group = "hunks" },
			{ "<leader>q", group = "quit/session" },
			{ "<leader>s", group = "search" },
			{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
			{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
			{ "gs", group = "surround" },
			{ "z", group = "fold" },
			{
				"<leader>b",
				group = "buffer",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
			{
				"<leader>w",
				group = "windows",
				proxy = "<c-w>",
				expand = function()
					return require("which-key.extras").expand.win()
				end,
			},
			-- better descriptions
			{ "gx", desc = "Open with system app" },
		},
	},
})
