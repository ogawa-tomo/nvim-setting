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
}
