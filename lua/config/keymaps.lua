-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>t", function()
  local count = vim.v.count
  local terminal_list = require("toggleterm.terminal").get_all()

  if count > 0 then
    -- 【ケース1】数字指定（2<leader>t など）がある場合
    -- その番号のターミナルのみをトグルする
    vim.cmd(count .. "ToggleTerm")
  else
    -- 【ケース2】数字指定がない場合
    if #terminal_list == 0 then
      -- ターミナルが1つも存在しなければ、1番目を開く
      vim.cmd("1ToggleTerm")
    else
      -- 1つ以上存在すれば、既存の全ターミナルの表示・非表示を切り替える
      -- ※ ToggleTermToggleAll は「存在する全ターミナル」の状態を反転させます
      vim.cmd("ToggleTermToggleAll")
    end
  end
end, { desc = "Smart ToggleTerm (Individual or All)" })

-- Ctrl + a で全選択
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })
-- Normal Mode: Ctrl + / でコメントアウト
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle Comment" })
-- Visual Mode: Ctrl + / で選択範囲をコメントアウト
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle Comment" })
-- Insert Mode: Ctrl + / で現在の行をコメントアウト
vim.keymap.set("i", "<C-_>", "<esc>gccA", { remap = true, desc = "Toggle Comment" })
-- Ctrl + s で保存 (ノーマル、挿入、ビジュアルモード)
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
-- x (1文字削除) はブラックホールレジスタへ送り、ヤンクしない
vim.keymap.set({ "n", "v" }, "x", '"_x')
-- Visual Mode: Tabでインデント、Shift + Tabで逆インデント
-- 実行後も選択範囲を維持するように設定
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent" })
-- Insert Mode: Shift + Tabでインデントを戻す
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Outdent" })

-- winresizerを起動するキーマップ
vim.keymap.set("n", "<leader>wr", ":WinResizerStartResize<CR>", { desc = "Window Resizer" })

-- カーソル行のPR URLをコピーする関数
local function copy_pr_url()
  local line = vim.fn.line(".")
  local file = vim.fn.expand("%")

  -- git blame でハッシュ取得
  local commit =
    vim.fn.system("git blame -L " .. line .. "," .. line .. " " .. file .. " | awk '{print $1}'"):gsub("%s+", "")

  if commit:find("^000000") or commit == "" then
    vim.notify("未コミットの行です", vim.log.levels.WARN)
    return
  end

  -- gh pr list --search を使用してURLを取得
  -- --json url --jq '.[0].url' で、見つかった最初のPRのURLを抽出
  local cmd = "gh pr list --search " .. commit .. " --state all --json url --jq '.[0].url'"
  local pr_url = vim.fn.system(cmd):gsub("%s+", "")

  if pr_url ~= "" and pr_url ~= "null" then
    vim.fn.setreg("+", pr_url)
    vim.notify("PR URLをコピー: " .. pr_url, vim.log.levels.INFO)
  else
    -- PRが見つからない場合はコミットURLをコピーする（予備動作）
    local repo_url = vim.fn.system("gh repo view --json url --jq '.url'"):gsub("%s+", "")
    local commit_url = repo_url .. "/commit/" .. commit
    vim.fn.setreg("+", commit_url)
    vim.notify("PR未検出のためコミットURLをコピーしました", vim.log.levels.WARN)
  end
end
vim.keymap.set("n", "<leader>gyp", copy_pr_url, { desc = "Copy PR URL for current line" })

-- pでペーストするときにWindowsの改行コードを除去する
local function paste_strip_cr(cmd)
  return function()
    local reg = vim.fn.getreg("+")
    if reg:find("\r") then
      vim.fn.setreg("+", (reg:gsub("\r", "")))
    end
    return cmd
  end
end
vim.keymap.set("n", "p", paste_strip_cr("p"), { expr = true, noremap = true })
vim.keymap.set("n", "P", paste_strip_cr("P"), { expr = true, noremap = true })

-- local wk = require("which-key")
-- wk.add({
--   { "<leader>t", group = "terminal" },
--   { "<leader>w", group = "resize window" },
-- })
