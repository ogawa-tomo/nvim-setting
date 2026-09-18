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
    -- LazyVimはK(hover)をnoice.nvimの独自ポップアップに差し替えているが、
    -- noiceの配置ロジックだとカーソル行に被って表示され、確認したい変数自体が
    -- 隠れてしまうことがある。hoverだけNeovim標準の表示に戻す
    -- （標準表示はカーソル行と重ならないよう自動で位置調整される）。
    -- 枠線はvim.o.winborder(options.lua)がそのまま効くので追加設定は不要。
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          enabled = false,
        },
      },
    },
  },
  {
    -- hover等の一時的なfloat(buftype=nofile)ではコードブロックの背景色と言語名見出し
    -- (先頭の「lua」等)を無効化する。disable_backgroundはシンタックスハイライト自体は
    -- 残したまま背景の帯だけ消すオプション。winhighlightで力技に上書きすると
    -- treesitterの色まで巻き込んで消えてしまうため、render-markdown本体が提供する
    -- これらのオプションを使う。通常のmarkdownファイル(buftype="")には影響しない。
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      overrides = {
        buftype = {
          nofile = {
            code = {
              disable_background = true,
              language = false,
            },
          },
        },
      },
    },
  },
}
