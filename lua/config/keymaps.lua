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

local wk = require("which-key")
wk.add({
  { "<leader>t", group = "terminal" },
  { "<leader>w", group = "resize window" },
})
