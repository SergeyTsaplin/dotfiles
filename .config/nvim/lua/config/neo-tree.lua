local neotree = require("neo-tree")

neotree.setup({
  enable_git_status = true,
  sources = {
    "filesystem",
    "buffers",
    "git_status",
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_hidden = false, -- only works on Windows for hidden files/directories
    },
  },
  follow_current_file = {
    enabled = true,
  },
  group_empty_dirs = true,
  use_libuv_file_watcher = true,
})
