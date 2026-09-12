-- コミットハッシュからPRを検索し、開く/コピーを行う共通処理
local M = {}

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

--- 指定したコミットハッシュを含むPRを検索して開く/コピーする
--- @param commit string コミットハッシュ
function M.open_for_commit(commit)
  if commit == "" or commit:find("^000000") then
    vim.notify("未コミットの行です", vim.log.levels.WARN)
    return
  end

  -- gh pr list --search を使用して該当コミットのPRを取得（複数ヒットしうる）
  local cmd = "gh pr list --search " .. commit .. " --state all --json number,title,url,mergedAt"
  local ok, prs = pcall(vim.json.decode, vim.fn.system(cmd))
  if not ok or type(prs) ~= "table" then
    prs = {}
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

return M
