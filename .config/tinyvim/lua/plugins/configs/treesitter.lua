require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = { "lua", "go", "python", "markdown", "rust", "typespec" },
	sync_install = false,
	ignore_install = { "" }, -- List of parsers to ignore installing
	auto_install = true,

	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
})
