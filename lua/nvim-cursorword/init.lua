local M = {}

local fn = vim.fn
local api = vim.api

local DEFAULT_OPTIONS = {
  min_legnth = 3,
  hl = { underline = true },
}

local function matchdelete(clear_word)
  if clear_word then
    vim.w.cursorword = nil
  end
  if vim.w.cursorword_match_id then
    pcall(fn.matchdelete, vim.w.cursorword_match_id)
    vim.w.cursorword_match_id = nil
  end
end

local function matchstr(...)
  local ok, ret = pcall(fn.matchstr, ...)
  if ok then
    return ret
  end
  return ""
end

function M.matchadd()
  if vim.tbl_contains(M.options.disable_filetypes or {}, vim.bo.filetype) then
    return
  end

  local mode_table = api.nvim_get_mode()
  if (mode_table.mode ~= "v") then
    matchdelete(true)
    return
  end

  local visual_mark = fn.getpos("v")
  local cursor_mark = fn.getpos(".")
  local visual_line = visual_mark[2]
  local cursor_line = cursor_mark[2]

  if (visual_line ~= cursor_line) then
    matchdelete(true)
    return
  end

  local visual_column = visual_mark[3]
  local cursor_column = cursor_mark[3]

  local line = api.nvim_get_current_line()
  local selection = (visual_column > cursor_column)
    and line:sub(cursor_column, visual_column)
    or line:sub(visual_column, cursor_column)

  local cursorword = selection

  if cursorword == vim.w.cursorword then
    return
  end

  vim.w.cursorword = cursorword

  matchdelete()

  if
    #cursorword < (vim.g.cursorword_min_width or 3)
    or #cursorword > (vim.g.cursorword_max_width or 50)
    or cursorword:find("[\192-\255]+")
  then
    return
  end

  cursorword = fn.escape(cursorword, [[~"\.^$[]*]])
  vim.w.cursorword_match_id = fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
end

function M.matchdelete()
  matchdelete(true)
end

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", DEFAULT_OPTIONS, options or {})
  require'nvim-cursorword.commands'.CursorWordEnable(M.options.hl)
end

return M
