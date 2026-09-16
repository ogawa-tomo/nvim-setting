return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        grep = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },
    lazygit = {
      config = {
        os = {
          -- デフォルトの nvim-remote プリセットは編集のたびに新しいタブを開くため、
          -- 同じウィンドウでファイルを開き直すコマンドで上書きする
          edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
          editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
        },
      },
    },
  },
}
