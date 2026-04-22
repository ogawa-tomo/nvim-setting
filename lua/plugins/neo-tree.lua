return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_gitignored = false,
        hide_dotfiles = false,
        hide_by_name = {
          "node_modules",
        },
        never_show = {
          ".git",
        },
      },
    },
  },
}
