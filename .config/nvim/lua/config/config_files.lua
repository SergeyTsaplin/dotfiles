local telescope = require("telescope.builtin")

local function custom_git_files()
  local opts = {
    git_command = {
      "git",
      "--git-dir=$HOME/.cfg",
      "--work-tree=$HOME",
      "ls-files",
      "--cached",
      "--others",
      "--exclude-standard",
    },
  }
  telescope.git_files(opts)
end

-- Keymap or command to invoke it
vim.keymap.set("n", "<leader>cf", custom_git_files, { desc = "Telescope git_files for dotfiles" })
