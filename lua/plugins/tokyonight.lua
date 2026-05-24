return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- style = "moon",
    transparent = true,
    dark_float = false,
    dark_sidebar = false,
    on_highlights = function(hl)
      hl.Visual = { bg = "#2d4f67" }
      hl.Comment = { fg = "#7780a1" }
      -- options.luaに記載したWinBarBoldの定義（背景が透明、文字が白太字）
      hl.WinBarBold = {
        fg = "#FFFFFF",
        bg = "NONE",
        bold = true,
      }
      -- 標準の WinBar（バーの背景）も完全に透明（NONE）にする
      hl.WinBar = {
        bg = "NONE",
      }
      hl.WinBarNC = {
        bg = "NONE",
      }
    end,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}
