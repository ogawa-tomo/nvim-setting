-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "open terminal" })
vim.keymap.set("n", "<leader>t", function()
  -- 入力された数字（2<leader>t なら 2）を取得。数字なしなら 1 を使う
  local count = vim.v.count > 0 and vim.v.count or 1
  -- その番号で ToggleTerm を実行
  vim.cmd(count .. "ToggleTerm")
end, { desc = "Terminal (with count)" })

-- <leader>taでターミナルを出し入れする
local last_active_terms = {}
local function toggle_only_active_set()
  local terminal_list = require("toggleterm.terminal").get_all()
  local any_open = false

  -- 現在、一つでもターミナルが表示されているか確認
  for _, term in ipairs(terminal_list) do
    if term:is_open() then
      any_open = true
      break
    end
  end

  if any_open then
    -- 【表示中 → 非表示】
    -- 現在開いているターミナルの番号を記憶して閉じる
    last_active_terms = {}
    for _, term in ipairs(terminal_list) do
      if term:is_open() then
        table.insert(last_active_terms, term.id)
        term:close()
      end
    end
  else
    -- 【非表示 → 表示】
    -- 前回開いていた番号だけを復元。記憶がなければ1番を開く
    if #last_active_terms > 0 then
      for _, id in ipairs(last_active_terms) do
        vim.cmd(id .. "ToggleTerm")
      end
    else
      vim.cmd("1ToggleTerm")
    end
  end
end
-- キーマッピングに登録（例: <leader>ta）
vim.keymap.set("n", "<leader>ta", toggle_only_active_set, { desc = "Toggle only active terminals" })

local wk = require("which-key")
wk.add({
  { "<leader>t", group = "terminal" },
  { "<leader>w", group = "resize window" },
})
