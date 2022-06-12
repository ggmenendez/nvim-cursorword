local is_initialized = false

if is_initialized then
  return
end

local api = vim.api
local cw_commands = require'nvim-cursorword.commands'

vim.api.nvim_create_user_command('CursorWordDisable', cw_commands.CursorWordDisable, {})
vim.api.nvim_create_user_command('CursorWordEnable',  cw_commands.CursorWordEnable, {})
vim.api.nvim_create_user_command('CursorWordToggle',  cw_commands.CursorWordToggle, {})
