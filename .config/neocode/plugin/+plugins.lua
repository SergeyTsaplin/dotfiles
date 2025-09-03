-- ~/.config/nvim-new/plugin/plugins.lua
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { load = true })

require('gitsigns').setup({ signcolumn = false })


vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", version = vim.version.range("^1.11.0"), name = "catppuccin" }
})

require("catppuccin").setup({
    flavor = "auto",
    autointegration = true,
    integrations = {
        gitsigns = true,
    },
})

vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim", version = vim.version.range("^v2.22.0") }
})

require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
        enabled = true,
        sources = {
            explorer = {
                hidden = true
            },
        },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
})
