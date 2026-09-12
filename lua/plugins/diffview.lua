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
    opts = {
      keymaps = {
        file_history_panel = {
          {
            "n",
            "gp",
            function()
              local view = require("diffview.lib").get_current_view()
              if not view then
                return
              end
              local item = view.panel:get_item_at_cursor()
              if not item or not item.commit then
                return
              end
              require("util.pr_url").open_for_commit(item.commit.hash)
            end,
            { desc = "Open the PR containing the commit under the cursor" },
          },
        },
      },
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
