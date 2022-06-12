local Commands = {};
local augroupName = "CursorWord"

local api = vim.api

function Commands.CursorWordDisable()
  if vim.fn.exists("#" .. augroupName) == 0 then return end
  api.nvim_del_augroup_by_name(augroupName)
  require'nvim-cursorword'.matchdelete()
end

function Commands.CursorWordEnable(hl)
  if vim.fn.exists("#" .. augroupName) == 1 then return end

  local CursorWordGroup = api.nvim_create_augroup(augroupName, {})
  api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    group = CursorWordGroup,
    pattern = "*",
    callback = function ()
      if (hl) then api.nvim_set_hl(0, "CursorWord", hl) end
      require'nvim-cursorword'.matchadd()
    end
  })

  api.nvim_create_autocmd("WinLeave", {
    group = CursorWordGroup,
    pattern = "*",
    callback = require'nvim-cursorword'.matchdelete
  })

  require'nvim-cursorword'.matchadd()
end

function Commands.CursorWordToggle()
  if vim.fn.exists("#" .. augroupName) == 0 then
    CursorWordEnable()
  else
    CursorWordDisable()
  end
end

return Commands;
