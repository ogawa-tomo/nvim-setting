return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        gopls = {
          -- cmd_cwdは静的な文字列で、動的に解決されるroot_dirに追従できない。
          -- そのため、この時点で解決済みのconfig.root_dirをプロセスのcwdとして
          -- 使うカスタムcmdでgoplsを起動する。これをしないと、goplsはNeovim自身の
          -- cwdを引き継いでしまい、プロジェクトルートより上(例: ~/dev)で
          -- Neovimを開いた場合に`go list`が壊れる。
          cmd = function(dispatchers, config)
            return vim.lsp.rpc.start({ "gopls" }, dispatchers, { cwd = config.root_dir })
          end,
        },
      },
    },
  },
  {
    -- LazyVimはK(hover)の表示をnoice.nvimの独自ポップアップ(noice.lsp.hover)に
    -- 差し替えているため、vim.lsp.util.open_floating_previewをフックしても効かない。
    -- noiceの"hover" viewだけに枠線を付け、他のview(cmdline等)には影響させない。
    -- 背景色は変えず、既存のFloatBorderハイライト(枠線の色)をそのまま使う。
    "folke/noice.nvim",
    opts = {
      views = {
        hover = {
          border = { style = "rounded" },
        },
      },
    },
  },
}
