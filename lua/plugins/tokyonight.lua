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
      -- カーソル行以外の行番号（デフォルトは#3b4261と薄いので少し濃く）
      hl.LineNr = { fg = "#545c7e" }
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
      -- K(hover)専用の背景色。lua/plugins/lsp.luaのnoiceの"hover" view設定から
      -- winhighlightで指定して使う（NormalFloat自体は変えず、他のfloatには影響させない）
      hl.LspHoverNormal = { bg = "#1f2335" }
    end,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}
