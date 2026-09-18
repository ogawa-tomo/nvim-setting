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
    -- noiceの"hover" viewだけに背景色を設定し、他のview(cmdline等)には影響させない。
    "folke/noice.nvim",
    opts = {
      views = {
        hover = {
          win_options = {
            winhighlight = "Normal:LspHoverNormal",
          },
        },
      },
    },
  },
}
