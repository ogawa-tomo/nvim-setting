return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "Open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      {
        "<leader>gdl",
        ":DiffviewFileHistory<cr>",
        mode = "v",
        desc = "Line History",
      },
      { "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gd", group = "diffview" },
      },
    },
  },
}
