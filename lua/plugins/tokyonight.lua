return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true,
    on_highlights = function(hl)
      hl.Visual = { bg = "#2d4f67" }
    end,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}
