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

local wk = require("which-key")
wk.add({
  { "<leader>t", group = "terminal" },
  { "<leader>w", group = "resize window" },
})
