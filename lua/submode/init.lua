-- lua/submode/init.lua

local core = require("submode.core")
local state = require("submode.state")

local M = {}

function M.enter_with(...)
  return core.enter_with(...)
end

function M.leave_with(...)
  return core.leave_with(...)
end

function M.map(...)
  return core.map(...)
end

function M.unmap(...)
  return core.unmap(...)
end

function M.restore_options()
  return state.restore_options()
end

function M.current()
  return state.current_submode
end

return M
