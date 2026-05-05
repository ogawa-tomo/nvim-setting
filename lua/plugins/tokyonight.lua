return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- style = "moon",
    -- transparent = true,
    dark_float = false,
    dark_sidebar = false,
    on_highlights = function(hl)
      hl.Visual = { bg = "#2d4f67" }
      hl.Comment = { fg = "#7780a1" }
    end,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}
