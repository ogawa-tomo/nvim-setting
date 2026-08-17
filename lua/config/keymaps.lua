-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 全ターミナルを閉じる直前に表示されていたターミナルIDの集合を記憶する
local last_open_ids = {}
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
      -- 現在表示中のターミナルIDを収集
      local open_ids = {}
      for _, term in ipairs(terminal_list) do
        if term:is_open() then
          table.insert(open_ids, term.id)
        end
      end

      if #open_ids > 0 then
        -- 閉じる前に表示中IDを保存してから全部閉じる
        last_open_ids = open_ids
        vim.cmd("ToggleTermToggleAll")
      else
        -- 保存済みIDのうち、まだ存在するものだけを再表示
        local targets = {}
        for _, saved_id in ipairs(last_open_ids) do
          for _, term in ipairs(terminal_list) do
            if term.id == saved_id then
              table.insert(targets, saved_id)
              break
            end
          end
        end
        -- 保存済みIDが1つもなければ先頭のターミナルを開く
        if #targets == 0 then
          table.insert(targets, terminal_list[1].id)
        end
        for _, id in ipairs(targets) do
          vim.cmd(id .. "ToggleTerm")
        end
      end
    end
  end
end, { desc = "ToggleTerm" })

-- Ctrl + a で全選択
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })

-- Normal Mode: Ctrl + / でコメントアウト
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle Comment" })
-- Visual Mode: Ctrl + / で選択範囲をコメントアウト
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle Comment" })
-- Insert Mode: Ctrl + / で現在の行をコメントアウト
vim.keymap.set("i", "<C-_>", "<esc>gccA", { remap = true, desc = "Toggle Comment" })

-- for Mac
-- Normal Mode: Ctrl + / でコメントアウト
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle Comment" })
-- Visual Mode: Ctrl + / で選択範囲をコメントアウト
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle Comment" })
-- Insert Mode: Ctrl + / で現在の行をコメントアウト
vim.keymap.set("i", "<C-/>", "<esc>gccA", { remap = true, desc = "Toggle Comment" })

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

  -- gh pr list --search を使用して該当コミットのPRを取得（複数ヒットしうる）
  local cmd = "gh pr list --search " .. commit .. " --state all --json number,title,url,mergedAt"
  local ok, prs = pcall(vim.json.decode, vim.fn.system(cmd))
  if not ok or type(prs) ~= "table" then
    prs = {}
  end

  -- 選んだPRに対してブラウザで開くかクリップボードにコピーするかを選ばせる
  local function act_on_pr_url(pr_url)
    vim.ui.select({ "ブラウザで開く", "クリップボードにコピー" }, {
      prompt = "PR URLに対するアクションを選択:",
    }, function(action)
      if action == "ブラウザで開く" then
        vim.ui.open(pr_url)
      elseif action == "クリップボードにコピー" then
        vim.fn.setreg("+", pr_url)
        vim.notify("PR URLをコピー: " .. pr_url, vim.log.levels.INFO)
      end
    end)
  end

  -- 表示幅に収まるようにテキストを切り詰める（"..."を含めた表示幅がmax_width以下になる）
  local function truncate(text, max_width)
    if vim.fn.strwidth(text) <= max_width then
      return text
    end
    local ellipsis = "..."
    local budget = max_width - vim.fn.strwidth(ellipsis)
    if budget < 1 then
      return ellipsis
    end
    local result = ellipsis
    for i = vim.fn.strchars(text), 1, -1 do
      local part = vim.fn.strcharpart(text, 0, i)
      if vim.fn.strwidth(part) <= budget then
        result = part .. ellipsis
        break
      end
    end
    return result
  end

  if #prs == 1 then
    act_on_pr_url(prs[1].url)
  elseif #prs > 1 then
    -- 複数のPRが該当する場合はタイトル一覧から選ばせる
    vim.ui.select(prs, {
      prompt = "該当するPRが複数見つかりました。選択してください:",
      format_item = function(pr)
        local merged_date = pr.mergedAt and pr.mergedAt:sub(1, 10) or "未マージ"
        local prefix = string.format("#%d ", pr.number)
        local suffix = string.format(" (merged: %s)", merged_date)
        local max_title_width = math.max(10, vim.o.columns - vim.fn.strwidth(prefix) - vim.fn.strwidth(suffix) - 4)
        return prefix .. truncate(pr.title, max_title_width) .. suffix
      end,
    }, function(choice)
      if choice then
        act_on_pr_url(choice.url)
      end
    end)
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
