-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>r", function()
  vim.lsp.buf.rename()
end, { desc = "Rename Symbol" })
map("n", "<leader>t", "", { desc = "+test" })
map("n", "<leader>tt", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run File (Neotest)" })
map("n", "<leader>tT", function()
  require("neotest").run.run(vim.uv.cwd())
end, { desc = "Run All Test Files (Neotest)" })
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle Summary (Neotest)" })
map("n", "<leader>to", function()
  require("neotest").output_panel.toggle()
end, { desc = "Toggle Output Panel (Neotest)" })
map("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
