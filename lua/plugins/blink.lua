-- lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<CR>"] = {
        "accept",
        function(cmp)
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local line_before_cursor = line:sub(1, col)
          local ft = vim.bo.filetype

          ----------------------------------------------------
          -- Python 向けの特別なインデント制御
          ----------------------------------------------------
          if ft == "python" then
            -- 1. ブロック開始記号（: { ( [ 等）で終わっている場合は通常改行（1段深くなる）
            if line_before_cursor:match("[:%({%[]%s*$") then
              return false
            end

            -- 2. return 等の脱出文で終わっている場合は 1段浅くする
            local is_return = line_before_cursor:match("^%s*return%f[%s%c%p]")
              or line_before_cursor:match("^%s*pass%s*$")
              or line_before_cursor:match("^%s*break%s*$")
              or line_before_cursor:match("^%s*continue%s*$")
              or line_before_cursor:match("^%s*raise%f[%s%c%p]")

            if is_return then
              vim.schedule(function()
                local r = vim.api.nvim_win_get_cursor(0)[1]
                local cur_line = vim.api.nvim_get_current_line()
                local indent = cur_line:match("^(%s*)") or ""
                local sw = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop

                local new_indent_len = math.max(0, #indent - sw)
                local new_indent = indent:sub(1, new_indent_len)

                local left = cur_line:sub(1, col)
                local right = cur_line:sub(col + 1):match("^%s*(.*)$") or ""

                vim.api.nvim_buf_set_lines(0, r - 1, r, false, { left, new_indent .. right })
                vim.api.nvim_win_set_cursor(0, { r + 1, #new_indent })
              end)
              return true
            end

            -- 3. 空行（バックスペース等でインデント調整した行）の場合のみ、現在のインデントを維持
            if line:match("^%s*$") then
              vim.schedule(function()
                local r = vim.api.nvim_win_get_cursor(0)[1]
                local cur_line = vim.api.nvim_get_current_line()
                local indent = cur_line:match("^(%s*)") or ""

                local left = cur_line:sub(1, col)
                local right = cur_line:sub(col + 1):match("^%s*(.*)$") or ""

                vim.api.nvim_buf_set_lines(0, r - 1, r, false, { left, indent .. right })
                vim.api.nvim_win_set_cursor(0, { r + 1, #indent })
              end)
              return true
            end
          end

          ----------------------------------------------------
          -- 上記以外（通常のコード行や Python 以外の言語）は標準改行に任せる
          ----------------------------------------------------
          return false
        end,
        "fallback",
      },
    },
  },
}
