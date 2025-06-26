-- lua/submode/state.lua
local M = {}

local function backup_vim_options()
	M.original_options = {
		showcmd = vim.o.showcmd,
		showmode = vim.o.showmode,
		timeout = vim.o.timeout,
		timeoutlen = vim.o.timeoutlen,
		ttimeout = vim.o.ttimeout,
		ttimeoutlen = vim.o.ttimeoutlen,
	}
end
backup_vim_options()

M.options_overridden = false
M.current_submode = ""

M.config = {
  always_show = vim.g.submode_always_show_submode or false,
  keep_leaving_key = vim.g.submode_keep_leaving_key or false,
  keyseqs_to_leave = vim.g.submode_keyseqs_to_leave or { "<Esc>" },
  timeout = vim.g.submode_timeout or vim.o.timeout,
  timeoutlen = vim.g.submode_timeoutlen or vim.o.timeoutlen,
}

function M.set_up_options(submode)
  if M.options_overridden then return end
  M.options_overridden = true

  backup_vim_options()

  vim.o.showcmd = true
  vim.o.showmode = false
  vim.o.timeout = M.config.timeout
  vim.o.ttimeout = M.original_options.timeout and true or M.original_options.ttimeout
  vim.o.timeoutlen = M.config.timeoutlen
  vim.o.ttimeoutlen = M.original_options.ttimeoutlen < 0 and M.original_options.timeoutlen or M.original_options.ttimeoutlen

  M.current_submode = submode
end

function M.restore_options()
  if not M.options_overridden then return end
  M.options_overridden = false

  for k, v in pairs(M.original_options) do
    vim.o[k] = v
  end

  M.current_submode = ""
end

return M
